<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class Planning extends Model
{
	use Notifiable;

	protected $table = 'planning';
	public $timestamps = false;
    public $incrementing = false;

    protected $fillable = [
    	'uid',
        'home', 
        'tour',
        'pos',
        'bool',
        'dist',
        'length'
    ];

    public function getHomeAttribute($value) {
        return json_decode(str_replace(['{', '}'], ['[', ']'], $value));
    }

    public function getTourAttribute($value) {
        return json_decode($value)->datas;
    }

    public function getPosAttribute($value) {
        return json_decode(str_replace(['{', '}'], ['[', ']'], $value));
    }

    public function getBoolAttribute($value) {
        return json_decode($value)->datas;
    }

    public function getDistAttribute($value) {
        return json_decode(str_replace(['{', '}'], ['[', ']'], $value));
    }
}
