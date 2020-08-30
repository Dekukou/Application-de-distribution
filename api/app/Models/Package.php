<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class Package extends Model
{
    use Notifiable;

    protected $table = 'package';
    public $timestamps = false;
    public $incrementing = false;
    protected $primaryKey = 'uid';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
    	'uid',
        'pos', 
        'todo'
    ];

    public function getPosAttribute($value) {
        return json_decode(str_replace(['{', '}'], ['[', ']'], $value));
    }

    public function setPosAttribute($value) {
        $this->attributes['pos'] = str_replace(['[', ']'], ['{', '}'], json_encode($value));
    }
}
