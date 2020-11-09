<?php

$db = pg_connect('dbname=misty user=wired') or die('no connecto');

require './vendor/autoload.php';
use Twilio\Rest\Client;

$account_sid = 'SID';
$auth_token = 'TOKEN';

$a=array();

$mobile = $_SERVER['HTTP_X_MOBILE_NUMBER'];
$hash_mobile = hash('sha256',$mobile,false);

if (substr($mobile,0,1)!='+')
{
	$mobile = '+1'.$mobile;
}

$a=strtoupper(bin2hex(random_bytes(4)));


$sql = "SELECT * FROM saccnts WHERE pnhash=".
	pg_escape_literal($db,$hash_mobile);
$res = pg_query($db,$sql);
if (pg_num_rows($res)>0)
{
	$row = pg_fetch_array($res);
	$sql = "UPDATE saccnts SET acode=".
		pg_escape_literal($db,$a).",request=".
		pg_escape_literal($db,time())." WHERE idx=".
		pg_escape_literal($db,$row['idx']);
} else {
	$sql = "INSERT INTO saccnts (pnhash,acode,sequence,request) VALUES (".
		pg_escape_literal($db,$hash_mobile).",".
		pg_escape_literal($db,$a).",".
		pg_escape_literal($db,time()).",".
		pg_escape_literal($db,time()).")";
	pg_query($db,$sql);
}
pg_free_result($res);
pg_close($db);

$client = new Client($account_sid, $auth_token);
$client->messages->create(
$mobile,
    array(
        'from' => '+16509008557',
        'body' => 'Your access code is: '.$a
    )
);


