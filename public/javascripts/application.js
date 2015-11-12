// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* Action New_or_edit, controller audiencias */
$(function() {
    $j('#audiencia_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

$(function() {
    $j('#ausencia_inicio').datetimepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

$(function() {
    $j('#ausencia_fin').datetimepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

/* Action New or edit, controller participantes */

$(function() {
    $j('#participante_fechahora_captura').datetimepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

$(function() {
    $j('#participante_fechahora_libertad').datetimepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});


$(function() {
    $j('#participante_fechahora_puesta_a_disposicion').datetimepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

