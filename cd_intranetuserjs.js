
$(document).ready(function(){

/*Make report result columns sortable on the fly and options able to be toggled on collection development reports, updated 6 26 20 for 19 11 chnages*/
if (window.location.href.indexOf("https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=") > -1){
$('th').click(function(){
    var table = $(this).parents('table').eq(0)
    var rows = table.find('tr:gt(0)').toArray().sort(comparer($(this).index()))
    this.asc = !this.asc
    if (!this.asc){rows = rows.reverse()}
    for (var i = 0; i < rows.length; i++){table.append(rows[i])}
});
function comparer(index) {
    return function(a, b) {
        var valA = getCellValue(a, index), valB = getCellValue(b, index)
        return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.toString().localeCompare(valB)
    }
};
function getCellValue(row, index){ return $(row).children('td').eq(index).text() };

$('th').addClass( "reportsort" );
}

var $sortable = $('.reportsort');

$sortable.on('click', function(){

  var $this = $(this);
  var asc = $this.hasClass('asc');
  var desc = $this.hasClass('desc');
  $sortable.removeClass('asc').removeClass('desc');
  if (desc || (!asc && !desc)) {
    $this.addClass('asc');
  } else {
    $this.addClass('desc');
  }
});

/*hide or show additional parameters on collections development reports*/
$("#rep_guided_reports_start li:contains('What'):contains('?:')").addClass("optcat");
$("#rep_guided_reports_start li:contains('Starting Call'):contains('?:')").addClass("optcat");
$("#rep_guided_reports_start li:contains('Ending Call'):contains('?:')").addClass("optcat");
$("#rep_guided_reports_start li:contains('Should lost/missing items be included?:')").addClass("optcat");
$("#rep_guided_reports_start li:contains('Should withdrawn items be included?:')").addClass("optcat");
$("#rep_guided_reports_start .optcat").hide();

$("#rep_guided_reports_start li:contains('Starting Call'):contains('?:')").append("<br /><font color='red'>(must change both)</font>");

	 $('input[type=text]').ready(function() {
    var yourFormFields = $("#rep_guided_reports_start li:contains('Call Number'):contains('?:')").find(':input[type=text]');

	yourFormFields.val('all');
     });

$("#rep_guided_reports_start li:contains('Worn Threshold:')").append("<div class='optmenu' style='padding-left:60px'><p>More options&nbsp;&nbsp;&nbsp;<img class='showopt' src='https://***path/to/your/server/files/toggle_menu.svg' height='16px;' width='32px;'/></p></div>");

$("#rep_guided_reports_start li:contains('Years NOT Circulated:')").append("<div class='optmenu' style='padding-left:60px'><p>More options&nbsp;&nbsp;&nbsp;<img class='showopt' src='https://***path/to/your/server/files/toggle_menu.svg' height='16px;' width='32px;'/></p></div>");

$("#rep_guided_reports_start li:contains('Items Published Before This Year')").append("<div class='optmenu' style='padding-left:60px'><p>More options&nbsp;&nbsp;&nbsp;<img class='showopt' src='https://***path/to/your/server/files/toggle_menu.svg' height='16px;' width='32px;'/></p></div>");

$("#rep_guided_reports_start li:contains('Run Inventory for which branch?')").append("<div class='optmenu' style='padding-left:60px'><p>More options&nbsp;&nbsp;&nbsp;<img class='showopt' src='https://***path/to/your/server/files/toggle_menu.svg' height='16px;' width='32px;'/></p></div>");


$( ".showopt" ).click(function() {
  $("#rep_guided_reports_start .optcat").toggle();
});


});


/*add link to Collections Development Reports*/
$(document).ready(function(){

 if (window.location.href.indexOf("https://***your-koha-server/cgi-bin/koha/mainpage.pl") > -1) {

  $(".biglinks-list li:contains('Authorities')").prepend("<li><a class='icon_general icon_course_reserves' href='/cgi-bin/koha/reports/guided_reports.pl?reports=1&phase=Run this report'><img src='https://***path/to/your/server/files/cd_top_col.svg' style='width: 46px; position:absolute;; margin: -4px; background-color: #f4f8f9; '>Collections Development (Beta)</a></li>");
  }


$(".dropdown-menu-right li:contains('Purchase Suggestions')").after('<li><a href="/cgi-bin/koha/reports/guided_reports.pl?reports=1&phase=Run this report">Collections Development (Beta)</a></li>');


});

/*Collections Development hide review again damaged status from issue and holding table */

$(document).ready(function(){

$("#holdings_table .dmg:contains('Review condition later')").hide();

//Hide dmg class
  $('#issues-table').on( 'ajaxSend.dt', function () {
  $("#issues-table .dmg:contains('Review condition later')").hide();

});

$('#issues-table').on( 'init.dt', function () {
  $("#issues-table").find(".dmg:contains('Review condition later')").hide();
});
//end Hide dmg class


});
