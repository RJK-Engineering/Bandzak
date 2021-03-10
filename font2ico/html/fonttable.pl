use strict;
use warnings;

my $fontFamily = shift // "Wingdings";
my $fontSize = "10pt";
my $fontColor = "#000";
my $backgroundColor = "#FFF";

print <<EOF;
<!DOCTYPE html>
<html>
<head>
    <title>dings</title>
    <style type="text/css">
        body {
            margin: 0;
            background-color: $backgroundColor;
        }
        table {
            font-family: $fontFamily;
            font-size: $fontSize;
            color: $fontColor;
            text-align: center;
            border-collapse: collapse;
            border-size: 0;
        }
        td {
            padding: 0;
        }
    </style>
</head>
<body>
<table id="table">
EOF

my $i = 32;
for (1..28) {
    print "<tr>";
    for (1..8) {
        print "<td>&#$i;</td>";
        $i++;
    }
    print "</tr>\n";
}

print <<EOF;
</table>
</body>

<script type="text/javascript">
    table = document.getElementById('table');
    rows = table.rows;
    var maxWidth = 0;
    var maxHeight = 0;

    for (var i = 0; i < rows.length; i++) {
        cells = rows[i].cells;
        for (var j = 0; j < cells.length; j++) {
            if (cells[j].offsetWidth > maxWidth) maxWidth = cells[j].offsetWidth;
            if (cells[j].offsetHeight > maxHeight) maxHeight = cells[j].offsetHeight;
        }
    }

    table.style.width = (rows[0].cells.length * maxWidth) + 'px';
    table.style.height = (rows.length * maxHeight) + 'px';
    maxWidth += 'px';
    maxHeight += 'px';

    console.log("Cells: " + rows[0].cells.length + " x " + rows.length);
    console.log("Cell Size: " + maxWidth + " x " + maxHeight);
    console.log("Table Size: " + table.style.width + " x " + table.style.height);

    for (var i = 0; i < rows.length; i++) {
        cells = rows[i].cells;
        for (var j = 0; j < cells.length; j++) {
            cells[j].style.width = maxWidth;
            cells[j].style.height = maxHeight;
        }
    }
</script>

</html>
EOF
