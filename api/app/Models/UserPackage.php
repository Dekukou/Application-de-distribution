<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class UserPackage extends Model
{
    protected $table = 'package_user';
    public $timestamps = false;
    public $incrementing = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_uid',
        'package_uid',
        'last',
        'dist',
        'total_dist',
        'done',
        'deivery_date'
    ];

    public function getLastAttribute($value) {
        return json_decode(str_replace(['{', '}'], ['[', ']'], $value));
    }

    public function setLastAttribute($value) {
        $this->attributes['last'] = str_replace(['[', ']'], ['{', '}'], json_encode($value));
    }
}
