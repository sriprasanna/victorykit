$(document).ready(function() {
	var domains = ['hotmail.com', 'gmail.com', 'aol.com', 'yahoo.com','msn.com','comcast.net','bellsouth.net','verizon.net','earthlink.net','cox.net','rediffmail.com','yahoo.ca','btinternet.com','charter.net','shaw.ca','ntlworld.com'];
	var $email = $('#signature_email');
	var $hint = $("#hint");

	$('.suggested_email').live("click",function() {
        $email.val($(this).html());
        $hint.css('display', 'none');
        return false; 
    });

	$('form').on("submit", function(event) {
		mailCheckSuggestions(event);
		return event.go;
    });

	function mailCheckSuggestions(event) {
		$hint.css('display', 'none');
	  	$email.mailcheck({
	  	domains: domains,
	    suggested: function(element, suggestion) {
	    	event.go = true;
	       	if(!$hint.html()) {
	        	var suggestion = 'Did you mean <a href="#" id="suggested_email" class="suggested_email">' + suggestion.full + "</a>?";              
	     	   	$hint.html(suggestion).fadeIn(150);
      			event.go = false;
	      }
	    }
	  });
	}
});

jQuery(function(){
	var cookie = $.cookie('signed_petitions') || '';
	var petitionIds = cookie.split("|");
	var currentPetitionId = $('#petitionId').val();
	if ($.inArray(currentPetitionId, petitionIds) > -1) {
    $('#thanks-for-signing-message').show();
    $('#sign-up-form').hide();
    $('#thanksModal').modal('toggle');
  }
  $('#petition_description').wysihtml5();

});