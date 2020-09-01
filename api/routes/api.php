<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post("user", "UserController@register");
Route::post("login", "UserController@authenticate");
Route::get("getPlanning", "PackageController@getPlanning");
Route::get("deliverers", "UserController@getDeliverers");
Route::get("packages", "PackageController@getPackages");

Route::group(["middleware" => "auth:api"], function() {
	Route::get("user", "UserController@getUser");
	Route::put("user", "UserController@updateUser");
	Route::delete("user", "UserController@deleteUser");
	Route::put("delivery", "PackageController@delivery");

	Route::post("createPackage", "PackageController@createPackage");
	Route::put("chooseDeliverer", "UserController@dispoDeliveryMan");
	Route::put("choosePackage", "PackageController@choosePackage");
	Route::get("createPlanning", "PackageController@createPlanning");
	Route::get("planning", "PackageController@getUserPlanning");
	
});
