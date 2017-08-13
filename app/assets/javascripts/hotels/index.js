//=require jquery-ui.min

var $search_btn, selected_date;
$(document).ready(function () {
    $search_btn = $('#search-btn');
    var $date_picker = $( "#date-picker" );
    selected_date = $.datepicker.formatDate('dd-M-yy', new Date());

    $date_picker.val(selected_date);

    $search_btn.click(function (evt) {
        $(this).attr('disabled', true);
        performHotelSearchAndListHotels($('#search-ip').val());

        evt.stopImmediatePropagation();
    });

    $date_picker.datepicker({
        dateFormat: 'dd-M-yy',
        onSelect: function(selected) {
            selected_date = selected;
        }
    });

    $('#search-ip').bind('keypress', function (e) {
        var code = e.keyCode || e.which;
        if(code === 13) {
            $search_btn.trigger('click');
        }
    });

    $search_btn.trigger('click');

    $('#hotels-list').on('click', '.hotel-list-li .check-in-btn', function (evt) {
        var hotel = {};
        var $hotel_list = $(this).parent();
        hotel['place_id'] = $hotel_list.attr('data-hotel-id');
        hotel['name'] = $hotel_list.find('.hotel-name').attr('data-hotel-name');
        hotel['rating'] = $hotel_list.find('.hotel-rating').attr('data-hotel-rating');
        hotel['types'] = $hotel_list.find('.hotel-types').attr('data-hotel-types');
        hotel['vicinity'] = $hotel_list.find('.hotel-vicinity').attr('data-hotel-vicinity');

        performCheckIn(hotel, selected_date);
        evt.stopImmediatePropagation();
    })
});

function performHotelSearchAndListHotels(search_key) {
    showAlertMsg('Searching for '+search_key+' ...', 'loading');

    $.ajax({
        url: search_hotels_url,
        method: 'GET',
        data: { search_key: search_key },
        success: function(result) {
            listHotels(result.hotels);
            if(result.hotels.length === 0) {
                showAlertMsg('No results for '+search_key+'.', 'loading');
                triggerAutoHide();
            }
        },
        failure: function () {

        }
    });
}

function performCheckIn(hotel, selected_date) {
    showAlertMsg('Processing your request ...', 'loading');
    $.ajax({
        url: checkins_url,
        method: 'POST',
        data: { hotel: hotel, checkin_date: selected_date },
        success: function(result) {
            var type = result.status ? 'success' : 'error';
            showAlertMsg(result.message, type)
        },
        failure: function () {

        }
    });
}

function listHotels(hotels) {
    var $hotel_list = '';
    $.each(hotels, function (index, hotel) {
        var rating = hotel.rating == undefined ? 0 : hotel.rating;
        $hotel_list += '<li class="hotel-list-li" data-hotel-id="'+hotel.place_id+'">' +
            '<h3><span data-hotel-name="'+hotel.name+'" class="hotel-name">'+hotel.name+'</span></h3>' +
            '<h4>Rating: <span data-hotel-rating="'+rating+'" class="hotel-rating '+ratingColor(rating)+'">'+ rating+'★</span></h4>' +
            '<h4>Type: <span data-hotel-types="'+hotel.types.join()+'" class="hotel-types">'+typeSplitStyle(hotel.types)+'</span><h4>' +
            '<h4>Location: <span data-hotel-vicinity="'+hotel.vicinity+'" class="hotel-vicinity">'+hotel.vicinity+'</span></h4>'+
            '<button class="check-in-btn btn">Check In</button></li>'
    });

    $('#hotels-list').empty().append($hotel_list);
    $search_btn.removeAttr('disabled');
    $('.alert-msg').remove();
}

function showAlertMsg(msg, type){
    $('.alert-msg').remove();

    $("<div class='alert-msg "+type+"'>"+msg+"</div>").appendTo("body").css({top: "82px", left: "30%"});

    if('loading' != type) {
        triggerAutoHide();
    }
}
function triggerAutoHide() {
    setTimeout(function(){
        $('.alert-msg').fadeOut('fast')
    }, 3000);
}

function ratingColor(rating) {
    var color_class;
    if(rating >= 4) {
        color_class = 'good'
    } else if(rating>=3 && rating<4) {
        color_class = 'average'
    } else {
        color_class = 'poor'
    }

    return color_class;
}

function typeSplitStyle(types) {
    var $type_string = '';
    $.each(types, function (index, type) {
        $type_string += '<span class="high-light">'+type+'</span>'
    })

    return $type_string;
}
