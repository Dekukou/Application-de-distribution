<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Package;
use App\Models\UserPackage;
use Illuminate\Support\Str;	
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PackageController extends Controller
{
	public function createPackage(Request $request) {
		
		$validator = Validator::make($request->all(), [
            'x' => 'required|numeric|between:-56,56',
            'y' => 'required|numeric|between:-56,56',
        ]);

        if ($validator->fails()) {
            return response()->json([
                "message" => $validator->errors()->first()
            ], 400);
        }

        $uid = 'pkg-' . Str::random(13);

        $package = Package::create([
        	'uid' => $uid,
        	'todo' => false,
        	'done' => false
        ]);

        $package->pos = [$request->get('x'), $request->get('y')];

        $package->save();	

        return response()->json($request->get('y'));
	}

	public function choosePackage(Request $request) {
		$validator = Validator::make($request->all(), [
            'uid' => 'required|exists:package,uid',
            'bool' => 'required|boolean'
        ]);

		$package = Package::where('uid', $request->get('uid'))->update(['todo' => $request->get('bool')]);
	}

	public function delivery(Request $request) {
		$validator = Validator::make($request->all(), [
            'uid' => 'required|exists:package,uid',
            'bool' => 'required|boolean'
        ]);

		$package = Package::where('uid', $request->get('uid'))->update(['done' => $request->get('bool')]);
	}

	private function firstSortDistance($arr, $pos) {
		$result = [];

		foreach ($arr as $point) {
			$dist = sqrt(pow($point['pos'][0] - $pos[0], 2) + pow($point['pos'][1] - $pos[1], 2));
			
			array_push($result, [ceil($dist), $point]);
		}

		$dist = [];
		foreach ($result as $point) {
			$dist[] = $point[0];
		}
		array_multisort($dist, SORT_ASC, $result, SORT_NUMERIC);
		return $result;
	}

	private function sortDistance($arr, $pos) {
		$result = [];

		foreach ($arr as $point) {
			$dist = sqrt(pow($point[1]['pos'][0] - $pos[0], 2) + pow($point[1]['pos'][1] - $pos[1], 2));
			
			array_push($result, [ceil($dist), $point[1]]);
		}
		$dist = [];
		foreach ($result as $point) {
			$dist[] = $point[0];
		}
		array_multisort($dist, SORT_ASC, $result, SORT_NUMERIC);
		return $result;
	}

	private function calcDistanceTotal($newpos, $pos, $home) {
		$distA = sqrt(pow($newpos[0] - $pos[0], 2) + pow($newpos[1] - $pos[1], 2));
		$distB = sqrt(pow($newpos[0] - $home[0], 2) + pow($newpos[1] - $home[1], 2));
		return ceil($distA + $distB);
	}

	private function calcDistance($newpos, $pos) {
		return ceil(sqrt(pow($newpos[0] - $pos[0], 2) + pow($newpos[1] - $pos[1], 2)));
	}

	private function linkUserPackage($mailmen, $package) {
		UserPackage::create([
			'user_uid' => $mailmen['uid'],
			'package_uid' => $package[1]['uid'],
			'last' => $mailmen['last'],
			'dist' => $package[0],
			'total_dist' => $package[0] + $mailmen['length'],
			'done' => false,
			'delivery_date' => date('Y_m_d-H-i-s')
		]);
	}

	private function firstPackage($mailmens, $packages, $space, $mod) {
		$add = 0;
    	$loop = 0;
    	$index = [];
    	foreach ($mailmens as $mailmen) {
    		if ($loop == 0) {
    			$mailmen['last'] = $packages[0][1]['pos'];
    			$mailmen['tour'] = [$packages[0][1]['uid']];
    			$mailmen['bool'] = true;
    			$this->linkUserPackage($mailmen, $packages[0]);
    			$mailmen['length'] = $packages[0][0];
    			array_push($index, 0);
    		} elseif ($loop === count($mailmens) - 1 && count($mailmens) !== 1) {
    			$mailmen['last'] = $packages[count($packages) - 1][1]['pos'];
    			$mailmen['tour'] = [$packages[count($packages) - 1][1]['uid']];
    			$mailmen['bool'] = true;
    			$this->linkUserPackage($mailmen, $packages[count($packages) - 1]);
    			$mailmen['length'] = $packages[count($packages) - 1][0];
    			array_push($index, count($packages) - 1);
    		} else {
	    		$mailmen['last'] = $packages[$add][1]['pos'];
    			$mailmen['tour'] = [$packages[$add][1]['uid']];
    			$mailmen['bool'] = true;
    			$this->linkUserPackage($mailmen, $packages[$add]);
    			$mailmen['length'] = $packages[$add][0];
    			array_push($index, $add);
    		}
    		$add += ($loop <= $mod) ? $space + 1 : $space;
    		$loop++;
    	}

    	rsort($index);

    	foreach ($index as $ind) {
    		unset($packages[$ind]);
    	}
    	return [$mailmens, $packages];
	}

    public function createPlanning() {
    	$packages = Package::inRandomOrder()->select('pos', 'uid')->where([['todo', '=', true]])->get();
    	
    	foreach ($packages as $package) {
	    	UserPackage::where([['package_uid', '=', $package['uid']], ['done', '=', false]])->delete();
    	}

    	$mailmens = User::inRandomOrder()->select('uid', 'home')->where([['role', '=', '0'], ['dispo', '=', true]])->get();

    	if (count($mailmens) == 0) {
    		return response()->json([
    			"message" => "Aucun livreur sélectionné"
    		], 400);
    	}

    	if (count($packages) == 0) {
    		return response()->json([
    			"message" => "Aucun colis sélectionné"
    		], 400);
    	}

    	if (count($mailmens) > count($packages)) {
    		return response()->json([
    			"message" => "Nombre de livreur supérieur au nombre de colis"
    		], 400);
    	}

    	$packages = $this->firstSortDistance($packages, [0, 0]);
    	$space = intdiv(count($packages), count($mailmens));
    	$mod = fmod(count($packages), count($mailmens));

    	$result = $this->firstPackage($mailmens, $packages, $space, $mod);
    	$mailmens = $result[0];
    	$packages = $result[1];

    	$loop = ($mod > 0) ? $space + 1 : $space;
    	for ($i = 0; $i < $loop; $i++) { 
    		foreach ($mailmens as $mailmen) {
    			if ($mailmen['bool'] == true) {
    				if (!empty($packages)) {
	    				$tmp = $this->sortDistance($packages, $mailmens[$i]['last']);
	    				if ($this->calcDistanceTotal($tmp[0][1]['pos'], $mailmen['last'], $mailmen['home']) + $mailmen['length'] <= 240) {
	    					$mailmen['last'] = $tmp[0][1]['pos'];
    						$this->linkUserPackage($mailmen, $tmp[0]);
	    					$tmp2 = $mailmen['tour'];
	    					array_push($tmp2, $tmp[0][1]['uid']);
	    					$mailmen['tour'] = $tmp2;
	    					$mailmen['length'] += $this->calcDistance($tmp[0][1]['pos'], $mailmen['last']);
	    					unset($tmp[0]);
	    					$packages = $tmp;
	    				} else {
	    					$mailmen['bool'] = false;
	    				}
	    			}
    			}
    		}
    	}

    	foreach ($mailmens as $mailmen) {
    		$mailmen['length'] += $this->calcDistance($mailmen['home'], $mailmen['last']);
    		unset($mailmen['home']);
    		unset($mailmen['last']);
    		unset($mailmen['bool']);
    	}

    	return response()->json($mailmens);
    }
}
