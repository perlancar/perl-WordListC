package WordListC;

# DATE
# VERSION

use strict 'subs', 'vars';

sub new {
    my $class = shift;
    my $fh = \*{"$class\::DATA"};
    binmode $fh, "encoding(utf8)";
    unless (defined ${"$class\::DATA_POS"}) {
        ${"$class\::DATA_POS"} = tell $fh;
    }
    bless [], $class;
}

sub each_word {
    my ($self, $code) = @_;

    my $class = ref($self);

    my $fh = \*{"$class\::DATA"};

    seek $fh, ${"$class\::DATA_POS"}, 0;
    while (defined(my $word = <$fh>)) {
        chomp $word;
        $code->($word);
    }
}

sub pick {
    my ($self, $n) = @_;

    $n ||= 1;

    my $class = ref($self);

    my $fh = \*{"$class\::DATA"};

    seek $fh, ${"$class\::DATA_POS"}, 0;
    if ($n < 1) {
        die "Please specify a positive number of words to pick";
    } elsif ($n == 1) {
        # use algorithm from Learning Perl
        my $word;
        my $i = 0;
        while (defined(my $line = <$fh>)) {
            $i++;
            $word = $line if rand($i) < 1;
        }
        chomp($word);
        return $word;
    } else {
        my @words;
        my $i = 0;
        while (defined(my $line = <$fh>)) {
            $i++;
            if (@words < $n) {
                # we haven't reached $n, put word to result in a random position
                splice @words, rand(@words+1), 0, $line;
            } else {
                # we have reached $n, just replace a word randomly, using
                # algorithm from Learning Perl, slightly modified
                rand($i) < @words and splice @words, rand(@words), 1, $line;
            }
        }
        chomp(@words);
        return @words;
    }
}

sub word_exists {
    my ($self, $word) = @_;

    my $class = ref($self);

    my $fh = \*{"$class\::DATA"};

    seek $fh, ${"$class\::DATA_POS"}, 0;
    while (defined(my $line = <$fh>)) {
        chomp $line;
        if ($word eq $line) {
            return 1;
        }
    }
    0;
}

sub all_words {
    my ($self) = @_;

    my $class = ref($self);

    my $fh = \*{"$class\::DATA"};

    seek $fh, ${"$class\::DATA_POS"}, 0;
    my @res;
    while (defined(my $word = <$fh>)) {
        chomp $word;
        push @res, $word;
    }
    @res;
}

1;
# ABSTRACT: Word lists (custom sorted)

=head1 SYNOPSIS

Use one of the C<WordListC::*> modules.


=head1 DESCRIPTION

B<WordListC> is just like L<WordList> except that it does not impose ascibetical
sorting requirement. You can sort the wordlist in whatever order you need.


=head1 SEE ALSO

L<WordList>.
