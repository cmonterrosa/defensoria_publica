// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* Action New_or_edit, controller audiencias */
$(function() {
    $j('#audiencia_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/calendar.gif",
        lang:'es'
    });
});
