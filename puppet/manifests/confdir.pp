define puppet::confdir (
  $config_file = $title,
  $template     = '',
  $source       = '',
  $ensure       = $puppet::config_file_ensure,
  $owner        = $puppet::config_file_owner,
  $group        = $puppet::config_file_group,
  $mode         = $puppet::config_file_mode,
  ) {

  $config_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  $config_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $config_file_recurse = $ensure ? {
      directory => true,
      default => undef,
  }

  $config_file_ensure = $ensure
  $config_file_owner  = $owner
  $config_file_group  = $group
  $config_file_mode   = $mode

  if $puppet::config_dir {
    file { "puppet_config_${config_file}":
      path    => "${puppet::config_dir}/${config_file}",
      ensure  => $config_file_ensure,
      mode    => $config_file_mode,
      owner   => $config_file_owner,
      group   => $config_file_group,
      source  => $config_file_source,
      content => $config_file_content,
      recurse => $config_file_recurse,
      replace => $puppet::config_file_replace,
      audit   => $puppet::config_file_audit,
      notify  => $puppet::service_reference,
      backup  => ".${puppet::system_date}.bak",
    }
  }
}

