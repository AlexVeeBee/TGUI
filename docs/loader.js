var InDocs = false;
var pageOpen = true;
var docs;
function goToDoc(id) {
    $("body .mainPage .DocsContainer").empty();
    $("body .mainPage .DocsContainer").append(`<h1 class="contentLoading">Loading</h1>`);
    $(".mainPage .sidebar-container").removeAttr("mobileOpen")
    $(".mainPage .sidebar-mobile-closeBox").removeAttr("SideBarOpen")
    var itemjson
    $.getJSON("./docsIds.json", (data) => {
        var item = data[id]
        itemjson = item
        const nextURL = 'https://alexveebee.github.io/TGUI/?viewDoc='+id;
        // const nextURL = 'http://127.0.0.1:5500/docs/?viewDoc='+id;
        const nextTitle = 'Loading';
        const nextState = { additionalInformation: '' };
        if (!pageOpen) {
            window.history.pushState(nextState, nextTitle, nextURL);
        }
        pageOpen = false;
    }).then(() => {
        InDocs = true
        if (itemjson.title == undefined) {
        } else {
            $(".page-title").html(itemjson.title)
        }
        $("body .mainPage .DocsContainer").load("./Pages/"+itemjson.html, () => {
            $("body .main-Page .content .contentLoading").remove();
            var devBlogInfoContainer = "body .main-Page .content .devblog-container"
            // $(devBlogInfoContainer+" .NewsTitle[set]").html(itemjson.title)
            // $(devBlogInfoContainer+" .NewsDescription[set]").html(itemjson.description)
            // $(devBlogInfoContainer+" .NewsDate-release[set]").html(itemjson.newsReleased)
            // $("body .main-Page .content .devblog-container *[devblog_section_userid] ").each(( t, e ) => {
            //     var elementTarget = this
            //     var id = $(e).attr("devblog_section_userid")
            //     $(e).html("by "+users[id].name+" "+users[id].rank)
            // })
        });
    })
}

$(document).ready(() => {
    $.getJSON("./docsIds.json", (u) => {
        console.log("loaded docsIds")
        docs = u;
    })
//    $(".pageBkg-img").append(`<audio controls class="pageBkg-audio"autoplay><source src="./objects/Audio/Background Music.mp3" type="audio/mp3"></audio>`)
   // $(".pageBkg-img .pageBkg-audio").attr("src","./objects/Audio/Background Music.mp3")

    // shhhh, this is copied from stackoverflow | credit: Sameer Kazi   
    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
        return false;
    };
    // 
    $("body .mainPage .DocsContainer").empty();
    $("body .mainPage .DocsContainer").append(`<h1 class="contentLoading">Loading</h1>`);
    {
        $.getJSON("./docs.json", (u) => {
            console.log("loaded docs ids")
            for (let index = 0; index < u.length; index++) {
                const element = u[index];
                // console.log("index",index);
                console.log(element.title);
                $(".sidebar-container .sidebar-docs").append(`
                <div class="docContainer">
                    <div class="docs-title">`+element.title+`</div>
                    <div class="`+element.className +`">
                    
                    </div>
                </div>
                `)
                
                const docs = element.docs;
                for (let index = 0; index < docs.length; index++) {
                    const doc = docs[index];
                    // console.log("| index",index)
                    console.log("%c|"+doc.title, "color: orange;")
                    console.log("%c|"+doc.docId, "color: orange;")
                    var category = doc.category
                    if (category == undefined) {
                        category = "";
                    }
                    $(".sidebar-container .sidebar-docs ."+element.className).append(`
                        <button class="doc-item" onClick="goToDoc(`+doc.docId+`)">
                            <!--<div class="doc-item">
                            </div>-->
                                <div class="doc-item-img">
                                    <img src="./Objects/placeholder.png" alt="placeholder">
                                </div>
                                <div class="doc-item-title">
                                    <span class="doc-item-title-text">`+doc.title+`</span><br>
                                    <span>`+category+`</span>
                                </div>
                        </button>
                    `)
                }
            }
        })
    }
    if (!getUrlParameter("viewDoc")) {
        goToDoc(0)
    } else {
        goToDoc(getUrlParameter("viewDoc"))
    }
    $(window).on('popstate', function(e){
        if (!getUrlParameter("viewDoc")) {
            pageOpen = true;
            goToDoc(0)
        } else {
            pageOpen = true;
            goToDoc(getUrlParameter("viewDoc"))
        }
    });
    var sidebar = $(".mainPage .sidebar-container")
    var closeBox = $(".mainPage .sidebar-mobile-closeBox")
    $("header .sidebar-mobile-openClose").on('click', () => {
        if (sidebar.attr("mobileOpen")) {
            sidebar.removeAttr("mobileOpen")
            closeBox.removeAttr("SideBarOpen")
        }else {
            sidebar.attr("mobileOpen", "")
            closeBox.attr("SideBarOpen", "")
        }
    })
    $(document).on('click', ".mainPage .sidebar-mobile-closeBox", () => {
        sidebar.removeAttr("mobileOpen")
        closeBox.removeAttr("SideBarOpen")
    })
    // {
    //     var currentImgScale = 1

    //     $(".main-Page .content").on("click", ".devblog-container .devblog-contrubitor-section .devblog-contrubitor-container-made .img-clickable" , ( data ) => {
    //         $("body").css("overflow", "hidden"); $(".img-container-preview").attr("open", "");
    //         var elementTarget = data.currentTarget; 
    //         var img_targert;
    //         if ($(elementTarget).attr("prevSrc")) {
    //             img_targert = $(elementTarget).attr("prevSrc");
    //         } else {
    //             img_targert = $(elementTarget).attr("src");
    //         }
    //         $(".img-container-preview .img-container img").attr("src", img_targert)
    //         $(".img-container-preview .img-container img").css("opacity", "0.5");
    //         $(".img-container-preview .img-container img").on("load", () => {
    //             $(".img-container-preview .img-container img").css("opacity", "1");
    //             if ($(".img-container-preview .img-container img").width() > $(document).width()-1) {currentImgScale = 0.8; $(".img-container-preview .img-container .inner").css({transform: "scale(0.8)"});}
    //             if ($(".img-container-preview .img-container img").height() > $(document).height()) {currentImgScale = 0.8; $(".img-container-preview .img-container .inner").css({transform: "scale(0.8)"}); }
    //         })
    //     })
    //     // var matrixRegex = /matrix\((-?\d*\.?\d+),\s*0,\s*0,\s*(-?\d*\.?\d+),\s*0,\s*0\)/ ;
    //     // var scale = $(".img-container-preview .img-container .inner").css("-webkit-transform").match(matrixRegex)
        
    //     $(".img-container-preview .img-container .inner").draggable({
    //         scroll: false
    //     })
    //     $(".img-container-preview .img-container .inner").on("mousewheel", ( data ) => {
    //         if (data.originalEvent.deltaY < 1) { if(currentImgScale < 3 ) {currentImgScale += 0.1 } }
    //         if (data.originalEvent.deltaY > -1) { if(currentImgScale > 0.6 ) { currentImgScale -= 0.1 } }
    //         $(".img-container-preview .img-container .inner").css({transform: "scale("+currentImgScale+")"});
    //     })
    // }
    // $(".img-container-preview .exit-preview").on("click", ( data ) => {
    //     $(".img-container-preview").removeAttr("open")
    //     $("body").css("overflow", "auto")
    //     $(".img-container-preview .img-container .inner").css({top: 0, left: 0});
    //     $(".img-container-preview .img-container .inner").css("transform", "scale(1)");
    //     currentImgScale = 1
    // })
    // $(".img-container-preview .close-button").on("click", ( data ) => {
    //     $(".img-container-preview").removeAttr("open")
    //     $("body").css("overflow", "auto")
    //     $(".img-container-preview .img-container .inner").css({top: 0, left: 0});
    //     $(".img-container-preview .img-container .inner").css("transform", "scale(1)");
    //     currentImgScale = 1
    // })
})