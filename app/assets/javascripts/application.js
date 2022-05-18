// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require chosen-jquery
//= require tinymce
//= require bootstrap-datepicker
//= require select2/select2-full
//= swagger-ui
//= require_tree .


(function() {
  $(".chosen-tags").select2({
    tags: true,
    placeholder: "Choose an option",
    width: '100%'
  });
})
$(document).ready(function(){
  $('.datepicker').datepicker({
    format: 'dd-mm-yyyy'
  });
  
});

function passwordMatch(newPasswordId, confirmPasswordId, buttonClass) {
  $(buttonClass).attr("disabled", true);

  $("input[type=password]").keyup(function(){
    if($(newPasswordId).val() == $(confirmPasswordId).val() && $(confirmPasswordId).val().match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/) ) {
      $(".password-confirm-hint").removeClass("glyphicon-remove");
      $(".password-confirm-hint").addClass("glyphicon-ok");
      $(".password-confirm-hint").css("color","#00A41E");
      $(buttonClass).attr("disabled", false);
    } 
    else {
      $(".password-confirm-hint").removeClass("glyphicon-ok");
      $(".password-confirm-hint").addClass("glyphicon-remove");
      $(".password-confirm-hint").css("color","#FF0004");
      $(buttonClass).attr("disabled", true);
    }
  });

}
