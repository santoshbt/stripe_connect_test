$(document).ready(function(){
    $("#stripe_connect")
    .bind("ajax:beforeSend", function(xhr){
        console.log("Before");
        $(".stripe_result").html("Please wait..!");
    })
    .bind("ajax:success", function(evt, xhr, status, data){
        console.log("Success");
        $(".stripe_result").html("");
        $(".required_info").css('display', 'block');
    })
    .bind("ajax:error", function(evt, xhr, status, data){
        console.log("Error");
        $(".stripe_result").html("Something went wrong, please try again..!");
    });  
});

