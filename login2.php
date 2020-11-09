<?php

$mobile = $_SERVER['HTTP_X_MOBILE_NUMBER'];
$hash_mobile = hash('sha256',$mobile,false);

$code = $_SERVER['HTTP_X_CODE'];

$cutoff = strtotime('-15 minutes');

$db = pg_connect('dbname=misty user=wired') or die('no connecto');

$msg = '';
$session = '';

$sql = "SELECT * FROM saccnts WHERE pnhash=".
        pg_escape_literal($db,$hash_mobile)." AND acode=".
	pg_escape_literal($db,$code)." AND request>".
	pg_escape_literal($db,$cutoff);
$res = pg_query($db,$sql);
if (pg_num_rows($res)>0)
{
	$row = pg_fetch_array($res);
	if ($row['pubkey']=='')
	{
		$t=`/usr/local/bin/tnnewaccnt`;
		$r=json_decode($t,true);
		$sk = $r['SK'];
		$pk = $r['PK'];
		$msg = 'Your secret key is '.$sk.'. Do not lose it!';
		$sql = "UPDATE saccnts SET pubkey=".
			pg_escape_literal($db,$pk)." WHERE idx=".
			pg_escape_literal($db,$row['idx']);
		pg_query($db,$sql);
	}
	$session = bin2hex(random_bytes(100));
	$sql = "INSERT INTO slogins (account_idx,session,login,logout) VALUES (".
		pg_escape_literal($db,$row['idx']).",".
		pg_escape_literal($db,$session).",".
		pg_escape_literal($db,time()).",0)";
	pg_query($db,$sql);
}
pg_free_result($res);
pg_close($db);

$out = array();
$out[]=$session;
$out[]=$msg;
echo json_encode($out);


