<?php

namespace App\Http\Controllers;

use JWTAuth;
use App\Models\User;
use App\Models\Package;
use App\Models\UserPackage;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function register(Request $request) {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email|max:255|unique:user',
            'password' => 'required|string|min:6',
            'role' => 'required|in:0,1',
            'x' => 'required|numeric|between:-56,56',
            'y' => 'required|numeric|between:-56,56'
        ]);

        if ($validator->fails()) {
            return response()->json([
                "message" => $validator->errors()->first()
            ], 400);
        }

        $uid = 'mm-' . Str::random(13);

        $user = User::create([
        	'uid' => $uid,
        	'role' => $request->get('role'),
        	'dispo' => false,
            'email' => $request->get('email'),
            'password' => hash('sha256', $request->get('password')),
        ]);

        $user->home = [$request->get('x'), $request->get('y')];
        $user->save();

        $token = $user->createToken('MyApp')->accessToken;

        return response()->json([
            "message" => "Ok",
            "data" => [
                "token" => $token, 
                "user" => $user
            ],
        ], 201);
    }

    public function authenticate(Request $request) {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
            'role' => 'required|in:0,1'
        ]);
        if ($validator->fails()) {
            return response()->json([
                "message" => $validator->errors()->first()
            ], 400);
        }

        $user = User::whereEmail(request('email'))
            ->wherePassword(hash('sha256', request('password')))
            ->where('role', $request->get('role'))
            ->first();

        if (isset($user)) {
            $token = $user->createToken('MyApp')->accessToken;
            return response()->json([
                "message" => "Ok",
                "user" => $user,
                "token" => $token,
            ], 201);
        }
        return response()->json([
            "message" => "Not found",
        ], 404);
    }

    public function deleteUser() {
        $user = Auth::user();

        if ($user->delete()) {
            return response()->json([
                "message" => 'Ok',
            ], 200);
        }
        
        return response()->json([
            "message" => "Error during user deletion",
        ], 400);
    }

    public function getUser() {
        $connectedUser = Auth::user();
        $user = User::where('id', $connectedUser->id)->first();

        if ($user !== null) {
            return response()->json([
                "message" => "Ok",
                "datas" => $user
            ], 200);  
        }

        return response()->json([
            "message" => "Not found",
        ], 404);
    }

    public function getDeliverers() {
        $users = User::where('role', '0')->orderBy('id', 'asc')->get();

        if (count($users) == 0) {
            return response()->json([
                "message" => "Aucun livreur dans la DB",
                "datas" => null,
                "count" => 0
            ], 404);
        }
        
        return response()->json([
            "message" => "Ok", 
            "datas" => $users,
            "count" => count($users)
        ], 200);
    }

    public function updateUser(Request $request) {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'x' => 'required|numeric|between:-56,56',
            'y' => 'required|numeric|between:-56,56',
            'password' => 'string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                "message" => $validator->errors()->first(),
            ], 400);
        }

        $user = Auth::user();

        $email = User::where('email', $request->email)->first();
        if (isset($email) && $user->id !== $email->id) {
            return response()->json([
                "message" => "Email already taken",
            ], 401);
        }

        $datas['email'] = $request->get('email');

        if ($request->get('password') !== NULL) {
        	$datas['password'] = hash('sha256', $request->get('password'));
        }

        $user->home = [$request->get('x'), $request->get('y')];
        $user->save();

        User::where('id', $user->id)->update($datas);
        $user = Auth::user()->first();

        return response()->json([
            "message" => "Ok",
            "datas" => $user,
        ], 200);
    }

    public function dispoDeliveryMan(Request $request) {
    	$validator = Validator::make($request->all(), [
            'uid' => 'required|exists:user,uid',
            'bool' => 'required|boolean'
        ]);

        if ($validator->fails()) {
            return response()->json([
                "message" => $validator->errors()->first(),
            ], 400);
        }

        $user = Auth::user();

    	if ($user->role !== '1') {
    		return response()->json([
                "message" => 'Unauthorized',
            ], 401);
    	}

    	User::where('uid', $request->get('uid'))->update(['dispo' => $request->get('bool')]);

    	$user = User::where('uid', $request->get('uid'))->first();

    	return response()->json([
    		"message"=> "Ok", 
    		"datas" => $user
    	], 200);
    }
}
