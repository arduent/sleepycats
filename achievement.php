<?php
$db = pg_connect('dbname=misty user=wired') or die('no connecto');

$session = $_SERVER['HTTP_X_SESSION'];
$points = 500;

$sql = "SELECT * FROM slogins WHERE session=".
	pg_escape_literal($db,$session)." AND logout=0";
$res = pg_query($db,$sql);
if (pg_num_rows($res)>0)
{
	$row = pg_fetch_array($res);
	$account_idx = $row['account_idx'];
	$sql = "SELECT pubkey FROM saccnts WHERE idx=".
		pg_escape_literal($db,$account_idx);
	$xres = pg_query($db,$sql);
	if (pg_num_rows($xres)>0)
	{
		$xrow = pg_fetch_array($xres);
		$pubkey = $xrow['pubkey'];
		if ($pubkey!='')
		{
			$t=`/usr/local/bin/tnsendwt $pubkey $points`;
		}
	}
	pg_free_result($xres);
}
pg_free_result($res);
pg_close($db);

