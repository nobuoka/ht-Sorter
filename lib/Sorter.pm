use strict;
use warnings;
use utf8;

package Sorter;

=head1 NAME

Sorter -- 数値的に値をソートする

=head1 SYNOPSIS

  use Sorter;

  my $s = Sorter->new();
  $s->set_values( 1, 3, 2 );
  $s->get_values(); #=> 1, 3, 2
  $s->sort();
  $s->get_values(); #=> 1, 2, 3

  $s->add_values( 0, 2 );
  $s->get_values(); #=> 1, 2, 3, 0, 2

=head1 DESCRIPTION

このクラスは, 与えられた値を数値的に比較してソートします. 
Sorter オブジェクトはソート対象の値を保持するリストを内部に持ちます. 

=head2 Class methods

=over

=item Sorter->new()

内部に空のリストを持つ Sorter オブジェクトを生成します. 

=back

=cut

sub new {
    my $class = shift;
    bless {
        "values" => []
    }, $class;
}

=head2 Instance methods

=over

=item $sorter->set_values( LIST )

内部のリストを空にして, 引数で与えられた LIST の各値を内部のリストに放り込みます.  

=item $sorter->add_values( LIST )

引数で与えられた LIST の各値を内部のリストに放り込みます. 

=item $sorter->sort()

内部のリスト内の値を数値的に比較してソートします. 

=item $sorter->get_values()

内部のリストの値を返します.

=back

=cut

sub set_values {
    my $self = shift;
    $self->{"values"} = [@_];
}

sub add_values {
    my $self = shift;
    push @{$self->{"values"}}, @_;
}

sub sort {
    my $self = shift;
    #$self->{"values"} = [ sort{ $a <=> $b }( @{$self->{"values"}} ) ];
    my $len = @{$self->{"values"}};
    if( $len > 1 ) {
        $self->_sort_by_quick_sort( $self->{"values"}, 0, $len - 1 );
    }
}

sub get_values {
    my $self = shift;
    return @{$self->{"values"}};
}

# ---- library private methods ----

sub _sort_by_quick_sort {
    my $self = shift;
    my ( $aref, $bidx, $eidx ) = @_;
    # 要素数が 1 の場合
    if( $bidx == $eidx ) {
        return;
    }
    # 要素数が 2 の場合
    if( $bidx + 1 == $eidx ) {
        if( $aref->[$bidx] > $aref->[$eidx] ) { 
            ( $aref->[$bidx], $aref->[$eidx] ) = ( $aref->[$eidx], $aref->[$bidx] ); 
        }
        return;
    }
    # 要素数が 3 以上の場合
    my $i2 = $bidx;
    my $j2 = $eidx;
    my $p = $aref->[ $bidx + ( $eidx - $bidx ) / 2 ];
    while( 1 ) {
        my ( $i, $j );
        for( $i = $i2; $i < $eidx and $aref->[$i] < $p; ++ $i ) {} 
        for( $j = $j2; $bidx < $j and $p < $aref->[$j]; -- $j ) {} 
        if( $i < $j ) {
            ( $aref->[$i], $aref->[$j] ) = ( $aref->[$j], $aref->[$i] );
            $i2 = $i + 1;
            $j2 = $j - 1;
        } else {
            $self->_sort_by_quick_sort( $aref, $bidx, $i - 1 );
            $self->_sort_by_quick_sort( $aref, $i, $eidx );
            last;
        }
    }
}

1;
