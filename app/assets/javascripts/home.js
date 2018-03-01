$(document).ready(function(){
    $("#stripe_connect").on("click", () => {
        $.ajax({
            url: '/create_account',
            async: true,
            dataType: 'script',
            type: 'get',
            beforeSend: () => {
                $(".stripe_result").html("Please wait...");
            },
            success: () => {
                $(".stripe_result").html("");
                $(".required_info").css('display', 'block');
            },
            error: () => {

            }
        });
    });        
});