import 'foremancerts.pp'

node 'foreman.example.net' {
  class { 'foremancerts':
    incForemanKey => true,
    incRootCAKey  => true,
  }
  class { '::foreman':
    admin_password        => 'admin',
    client_ssl_ca         => '/var/lib/foreman/ssl/certs/ca.pem',
    client_ssl_cert       => '/var/lib/foreman/ssl/certs/foreman.example.net.pem',
    client_ssl_key        => '/var/lib/foreman/ssl/private_keys/foreman.example.net.pem',
    oauth_consumer_key    => 'AdnJjv3v7unVZ7UK8A53tbPJbFKCe6sx',
    oauth_consumer_secret => 'fdkmLrh9ueMEsesKUmbfYBmWeBXqASkK',
    puppetrun             => true,
    server_ssl_ca         => '/var/lib/foreman/ssl/certs/ca.pem',
    server_ssl_chain      => '/var/lib/foreman/ssl/certs/ca.pem',
    server_ssl_cert       => '/var/lib/foreman/ssl/certs/foreman.example.net.pem',
    server_ssl_certs_dir  => '/var/lib/foreman/ssl/certs/',
    server_ssl_key        => '/var/lib/foreman/ssl/private_keys/foreman.example.net.pem',
    server_ssl_crl        => '/var/lib/foreman/ssl/crl.pem',
    websockets_ssl_cert   => '/var/lib/foreman/ssl/certs/foreman.example.net.pem',
    websockets_ssl_key    => '/var/lib/foreman/ssl/private_keys/foreman.example.net.pem',
  }
  class { '::puppet':
    listen                  => true,
    listen_to               => [ 'foreman.example.net', 'puppet.example.net' ],
    puppetmaster            => 'puppet.example.net',
    server                  => false,
    server_foreman_url      => 'https://foreman.example.net',
    server_foreman_ssl_ca   => '/var/lib/foreman/ssl/certs/ca.pem',
    server_foreman_ssl_cert => '/var/lib/foreman/ssl/certs/puppet.example.net.pem',
    server_foreman_ssl_key  => '/var/lib/foreman/ssl/private_keys/puppet.example.net.pem',
  }
}

node 'puppet.example.net'  {
  class { 'foremancerts':
    owner        => 'foreman-proxy',
    incPuppetKey => true,
  }
  class { '::puppet':
    listen                  => true,
    listen_to               => [ 'foreman.example.net', 'puppet.example.net' ],
    puppetmaster            => 'puppet.example.net',
    server                  => true,
    server_foreman_url      => 'https://foreman.example.net',
    server_foreman_ssl_ca   => '/var/lib/foreman/ssl/certs/ca.pem',
    server_foreman_ssl_cert => '/var/lib/foreman/ssl/certs/puppet.example.net.pem',
    server_foreman_ssl_key  => '/var/lib/foreman/ssl/private_keys/puppet.example.net.pem',
  } ->
  class { '::foreman_proxy':
    dhcp                  => false,
    dns                   => false,
    foreman_base_url      => 'https://foreman.example.net',
    foreman_ssl_ca        => '/var/lib/foreman/ssl/certs/ca.pem',
    foreman_ssl_cert      => '/var/lib/foreman/ssl/certs/puppet.example.net.pem',
    foreman_ssl_key       => '/var/lib/foreman/ssl/private_keys/puppet.example.net.pem',
    oauth_consumer_key    => 'AdnJjv3v7unVZ7UK8A53tbPJbFKCe6sx',
    oauth_consumer_secret => 'fdkmLrh9ueMEsesKUmbfYBmWeBXqASkK',
    register_in_foreman   => true,
    ssl_ca                => '/var/lib/foreman/ssl/certs/ca.pem',
    ssl_cert              => '/var/lib/foreman/ssl/certs/puppet.example.net.pem',
    ssl_key               => '/var/lib/foreman/ssl/private_keys/puppet.example.net.pem',
    tftp                  => false,
    trusted_hosts         => [ 'foreman.example.net' ],
  }
}

node default {
  hiera_include('classes')
}
