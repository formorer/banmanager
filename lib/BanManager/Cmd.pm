package BanManager::Cmd;

use Moose;
extends qw(MooseX::App::Cmd );


package BanManager::Cmd::Error;
use Moose;
extends 'Throwable::Error';

1;