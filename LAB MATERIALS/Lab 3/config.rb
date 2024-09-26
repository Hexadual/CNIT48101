# config.rb
$vm_config = {
	'cpus' => 2,
	'memory' => 2048,
	'box' => 'ubuntu/bionic64',
	'master_name' => 'master',
	'worker1_name' => 'worker1',
	'worker2_name' => 'worker2',
	'network' => '192.168.56.',
	'network_base' => 50,
	'network_base1' => 51,
	'network_base2' => 52,
	'provisioners' => ['shell']
}
