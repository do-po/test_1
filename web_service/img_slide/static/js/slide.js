let slideIndex = 0;

    function showSlide(){
        // python과 다르게 다른 언어들은 변수에 값을 지정하지 않아도 변수 생성이 가능하다.
        let i;
        let slides = document.getElementsByClassName('slides')
        // '++' == '+= 1'
        // i가 0부터 시작, slides 길이보다 작을 때 까지 i += 1
        for (i=0; i<slides.length; i++){
            slides[i].style.display = 'none';
        }
        slideIndex++;
        if(slideIndex > slides.length){
            slideIndex = 1
        }
        slides[slideIndex -1].style.display = 'block';
        
        // 2000 단위 (== 2s)마다 한 번씩 showSlide 반복 실행
        setTimeout(showSlide, 2000)
    }