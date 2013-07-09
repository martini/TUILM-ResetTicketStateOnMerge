# Copyright (C) 2012 Znuny GmbH, http://znuny.com

package Kernel::System::Ticket::Event::ResetTicketStateOnMerge;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject TimeObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return if $Param{Event} ne 'TicketMerge';
    return if !$Param{Data};
    return if !$Param{Data}->{MainTicketID};

    $Self->{TicketObject}->TicketStateSet(
        TicketID           => $Param{Data}->{MainTicketID},
        State              => 'open',
        SendNoNotification => 1,
        UserID             => 1,
    );
    return 1;
}

1;
