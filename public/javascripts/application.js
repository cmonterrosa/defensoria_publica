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


/* Action New_or_edit, controller amparos */
$(function() {
    $j('#amparo_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

/* Action New_or_edit, controller promocion */
$(function() {
    $j('#promocion_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

/* Action New_or_edit, controller recurso */
$(function() {
    $j('#recurso_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

/* Action New_or_edit, controller sentencia */
$(function() {
    $j('#sentencia_fecha').datepicker({
        dayOfWeekStart : 1,
        buttonImage: "/images/icons/calendar.gif",
        lang:'es'
    });
});

/* Habilita descripcion del delito si tiene antecedentes penales */
function enable_descripcion_delito(){
    if (document.getElementById("participante_tiene_antecedentes_penales_si").checked == true)
        {document.getElementById("descripcion_delito").style.display = "inline";}
    else
        {document.getElementById("descripcion_delito").style.display = "none";}
  }
