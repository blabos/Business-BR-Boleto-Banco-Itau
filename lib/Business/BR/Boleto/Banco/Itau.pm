package Business::BR::Boleto::Banco::Itau;

use Moo;
with 'Business::BR::Boleto::Role::Banco';

use Business::BR::Boleto::Utils qw{ mod10 mod11 };

sub nome   { 'Itau' }
sub codigo { '341' }

sub campo_livre {
    my ( $self, $cedente, $pagamento ) = @_;

    my $nosso_numero = sprintf '%08d', $pagamento->nosso_numero;
    my $carteira     = sprintf '%03d', $cedente->carteira;
    my $agencia      = sprintf '%04d', $cedente->agencia->{numero};
    my $conta        = sprintf '%05d', $cedente->conta->{numero};
    my $conta_dv     = $cedente->conta->{dv};

    my $dac_nn = mod10( $agencia . $conta . $carteira . $nosso_numero );
    my $dac_ac = mod11( $agencia . $conta );

    $self->codigo_cedente( $agencia . '/' . $conta . '-' . $conta_dv );
    $self->nosso_numero( $carteira . '/' . $nosso_numero . '-' . $dac_nn );

    return
        $carteira
      . $nosso_numero
      . $dac_nn
      . $agencia
      . $conta
      . $dac_ac . '000';
}

1;

#ABSTRACT: Implementação das particularidades de boletos do Banco Itau

