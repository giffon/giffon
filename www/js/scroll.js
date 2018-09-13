$(function(){

	$(window).scroll(function (event) {
		var scroll = $(window).scrollTop();
		var sett = $('#set').offset();

		if( scroll >= (sett.top - 900) ) {
			$('#set2').removeClass('invisible').addClass('from_right');
		}

		if( scroll >= (sett.top - 200) ) {
			$('#support').removeClass('invisible').addClass('from_left');
		}
	});

});