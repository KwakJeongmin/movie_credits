<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Insert title here</title>
	 <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.0/axios.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .search-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .search-box {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 600px;
        }
        .search-title {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        .search-input {
            border-radius: 50px;
            padding: 15px 25px;
            font-size: 18px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .search-button {
            border-radius: 50px;
            padding: 15px 30px;
            font-size: 18px;
            background-color: #007bff;
            border: none;
            transition: all 0.3s ease;
        }
        .search-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
	<script>
        /**************************************************
        * Ready
        **************************************************/
        jQuery(document).ready(function() {
            fncSetEvent();
        });
        
        /**************************************************
         *  FUNCTION 명 : fncSetEvent
         *  FUNCTION 기능설명 : 페이지 버튼 이벤트
         **************************************************/
        function fncSetEvent() {
            jQuery('#btnSearch').on('click', function() {
                fncSearchMovieCd();
            });
        }
        
        /**************************************************
        *  FUNCTION 명 : fncSearchMovieCd
        *  FUNCTION 기능설명 : 영화 코드 조회
        **************************************************/
        function fncSearchMovieCd() {
            var movieTitl = $('#movieTitl').val();
            var movieNm = encodeURIComponent(movieTitl);
            
            const srchCdUrl = "https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=키값&movieNm=" + movieNm;
            
            $.ajax({
                url: srchCdUrl,
                method: 'GET',
                success: function(data) {
                    var movieCd = data.movieListResult.movieList[0].movieCd;
                    fncSearchMovieInfo(movieCd);
                },
                error: function(err) {
                    console.error(err);
                }
            });
        }
        
        /**************************************************
         *  FUNCTION 명 : fncSearchMovieInfo
         *  FUNCTION 기능설명 : 영화 상세정보 조회
         **************************************************/
         function fncSearchMovieInfo(movieCd) {
             const srchInfoUrl = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=키값&movieCd=" + movieCd;
             
             $.ajax({
                 url: srchInfoUrl,
                 method: 'GET',
                 success: function(data) {
                     var movieInfo = data.movieInfoResult.movieInfo;
                     
                     // 영화 기본 정보 표시
                     var infoHtml = movieInfo.movieNm + '<br>' +
                         '<span style="font-size: 1rem; color: #ffd700;">' +
                         (movieInfo.openDt || '정보 없음') + ' | ' +
                         (movieInfo.showTm || '정보 없음') + '분 | ' +
                         (movieInfo.genres.map(function(g) { return g.genreNm; }).join(', ') || '정보 없음') +
                         '</span>';
                     $('#modalMovieInfo').html(infoHtml);
                     
                     // 출연진 정보 초기화
                     $('#modalActors').empty();
                     
                     // 출연진 정보 for문으로 추가
                     for(var i = 0; i < movieInfo.actors.length; i++) {
                         var actor = movieInfo.actors[i];
                         var actorHtml = '<div>' +
                             '<h5 class="card-title">' + actor.peopleNm + '</h5>' +
                             '<p class="card-text">' + (actor.cast || actor.castEng || '배역정보 없음') + '</p>' +
                         '</div>';
                         $('#modalActors').append(actorHtml);
                     }
                     
                     // 제작진 정보 초기화
                     $('#modalStaff').empty();
                     
                     // 제작진 정보 for문으로 추가
                     for(var i = 0; i < movieInfo.staffs.length; i++) {
                         var staff = movieInfo.staffs[i];
                         var staffHtml = '<div>' +
                             '<h5 class="card-title">' + staff.peopleNm + '</h5>' +
                             '<p class="card-text">' + staff.staffRoleNm + '</p>' +
                         '</div>';
                         $('#modalStaff').append(staffHtml);
                     }
                     
                     // 모달 표시
                     var movieModal = new bootstrap.Modal(document.getElementById('movieModal'));
                     movieModal.show();
                 },
                 error: function(err) {
                     console.error(err);
                     alert('영화 정보를 가져오는데 실패했습니다.');
                 }
             });
         }
    </script>

    <div class="search-container">
        <div class="search-box">
            <h1 class="search-title">Movie Credits Search</h1>
            <form id="searchForm">
                <div class="mb-4">
                    <input type="text" class="form-control search-input" id="movieTitl" name="movieTitl" placeholder="영화 제목을 입력하세요...">
                </div>
                <div class="text-center">
                    <button type="button" class="btn btn-primary search-button" id="btnSearch">크레딧 보기</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 영화 정보 모달 -->
    <div class="modal fade" id="movieModal" tabindex="-1" aria-labelledby="movieModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" style="max-width: 90vw;">
            <div class="modal-content credits-modal">
                <div class="modal-header border-0">
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body credits-scroll">
                    <div class="credits-container">
                        <div class="movie-info-section text-center mb-5">
                            <h2 class="credits-title mb-4" id="modalMovieInfo"></h2>
                        </div>
                        <div class="actors-section mb-5">
                            <h3 class="credits-section-title text-center mb-4">출연진</h3>
                            <div id="modalActors" class="credits-grid"></div>
                        </div>
                        <div class="staff-section mb-5">
                            <h3 class="credits-section-title text-center mb-4">제작진</h3>
                            <div id="modalStaff" class="credits-grid"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .credits-modal {
            background-color: #000000;
            color: #ffffff;
            border: none;
        }
        .credits-scroll {
            height: 80vh;
            overflow-y: auto;
            padding: 2rem;
        }
        .credits-scroll::-webkit-scrollbar {
            width: 8px;
        }
        .credits-scroll::-webkit-scrollbar-track {
            background: #000000;
        }
        .credits-scroll::-webkit-scrollbar-thumb {
            background: #ffffff;
            border-radius: 4px;
        }
        .credits-container {
            animation: scrollCredits 2s ease-out;
        }
        .credits-title {
            font-size: 2.5rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #ffffff;
        }
        .credits-section-title {
            font-size: 1.8rem;
            color: #ffd700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .credits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 0 2rem;
        }
        .credits-grid > div {
            text-align: center;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        .credits-grid > div:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.2);
        }
        .card-title {
            font-size: 1.2rem;
            color: #ffffff;
            margin-bottom: 0.5rem;
        }
        .card-text {
            color: #ffd700;
            font-size: 0.9rem;
        }
        @keyframes scrollCredits {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</body>
</html>