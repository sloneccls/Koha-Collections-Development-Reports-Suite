
                $(".col-sm-10").prepend("<div id='navmenu' class='coldevmenu'><div id='navmenulist' class='coldevli'><h5>Worn Items</h5><ul><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=2&amp;phase=Run%20this%20report'>Worn and Torn Items</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=4&amp;phase=Run%20this%20report'>Replacement Pulls</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=5&amp;phase=Run%20this%20report'>Items Marked Review Later</a></li></ul><h5>Good Performers</h5><ul><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=6&amp;phase=Run%20this%20report'>Highest Circulating Titles</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=7&amp;phase=Run%20this%20report'>High Use Collections</a></li></ul><h5>Poor Performers</h5><ul><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=8&amp;phase=Run%20this%20report'>Dead on Arrival Items</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=9&amp;phase=Run%20this%20report'>Dusty Item Check</a></li></ul><h5>Tools</h5><ul><li><a href='https://***your-koha-server/cgi-bin/koha/tools/batchMod.pl'>Batch Item Modification</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=10&phase=Run%20this%20report'>Inventory</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=11&phase=Run%20this%20report'>Over\/UnderStocked</a></li><li><a href='https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=12&phase=Run%20this%20report'>Out-Dated Non-Fiction</a></li><h5>Instructions</h5><li><a href='https://***path/to/your/server/files/Draft%20Collection%20Development%20Reports%20and%20Procedures.pdf'>Worn Items Process</a></li></ul></div>");

$('#runreport').text('Reset report');

//updated on 8/13/20 to correct issues created after updated to 19 11 removed report results as a divider
$("table").prepend("<div id='params_sec' class='stylish'><h4>Settings:</h4><div id='params_used'></div></div>");


const regex = /@+[aA-zZ]*\s\:\=\s\'\S*/gm;
const str = $( "#sql" ).text();
let z;

while ((z = regex.exec(str)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (z.index === regex.lastIndex) {
        regex.lastIndex++;
    }
    // The result can be accessed through the `m`-variable.
    z.forEach((match) => {

	const regex = /@+[aA-zZ]*/g;
	const regexb = /'\S*'/g;
  var str = (match);
  let x;
  let y;

	while ((x = regex.exec(str)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (x.index === regex.lastIndex) {
        regex.lastIndex++;
    }

  	while ((y = regexb.exec(str)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (y.index === regexb.lastIndex) {
        regexb.lastIndex++;
    }

    var yv = y;

    };


    // The result can be accessed through the `m`-variable.
    x.forEach((match) => {

		$("#params_used").append("<p id='"+x+"'>"+yv+"</p>");


});

};	});		}

$("#toolbar").prepend("<div id='changeset' class='btn btn-default'>Change Settings</div>");

$('#changeset').on('click', function(e){
    e.preventDefault();
    window.history.back();
});

$("#\\@lost:contains('0')").html('<strong>Lost/missing items: </strong>Excluded');
$("#\\@lost:contains('1')").html('<strong>Lost/missing items: </strong>Included');
$("#\\@wd:contains('0')").html('<strong>Withdrawn items: </strong>Excluded');
$("#\\@wd:contains('1')").html('<strong>Withdrawn items: </strong>Included');
