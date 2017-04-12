<%@ Page Language="C#" CodeFile="register.aspx.cs" 
    Inherits="SamplePage" AutoEventWireup="true" %>

<html lang="ru">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Office 365</title>

        <!-- CSS -->
        <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
        <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="assets/css/form-elements.css">
        <link rel="stylesheet" href="assets/css/style.css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

        <!-- Favicon and touch icons -->
        <link rel="shortcut icon" href="assets/ico/favicon.png">
        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
        <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">

    </head>

    <body>

		<!-- Top menu -->
		<nav class="navbar navbar-inverse navbar-no-bg" role="navigation">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#top-navbar-1">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand2" href="index.html">Узнать про Office365 бесплатно!</a>
				</div>
				<!-- Collect the nav links, forms, and other content for toggling -->
				<div class="collapse navbar-collapse" id="top-navbar-1">
					<ul class="nav navbar-nav navbar-right">
						<li>
							<span class="li-text">
								Проект 
							</span> 
							<a href="http://www.osu.ru"><strong>ОГУ</strong></a> 
							<span class="li-text">
								для студентов и преподавателей.
							</span> 
						</li>
					</ul>
				</div>
			</div>
		</nav>

    <div class="col-sm-8 col-sm-offset-2 text" style="display:<%= hide2 %>">
	<%= message %>	
	</div>

    <div style="display:<%= hide %>">
        <!-- Top content -->
        <div class="top-content">
        	
            <div class="inner-bg">
                <div class="container">
                    <div class="row">
                        <div class="col-sm-8 col-sm-offset-2 text">
                            <h1><strong><a href='http://portal.office.com'>OFFICE 365</a></strong> для студентов и преподавателей ОГУ</h1>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6 col-sm-offset-3 form-box">
                        	
                        	<form role="form" action="/register.aspx" method="post" class="registration-form">
                        		
                        		<fieldset>
		                        	<div class="form-top">
		                        		<div class="form-top-left">
		                        			<h3>Шаг 1 / 3</h3>
		                            		<p>Проверьте учетные данные:</p>
		                        		</div>
		                        		<div class="form-top-right">
		                        			<i class="fa fa-user"></i>
		                        		</div>
		                            </div>
		                            <div class="form-bottom">
				                    	<div class="form-group">
				                    		<label class="sr-only" for="1name">First name</label>
				                        	<input readonly=yes type="text" name="1name" placeholder="Имя" class="form-first-name form-control" id="form-first-name"
     										value="<%= name %>">
				                        </div>
				                        <div class="form-group">
				                        	<label class="sr-only" for="form-last-name">Last name</label>
				                        	<input readonly=yes type="text" name="form-last-name" placeholder="Фамилия" class="form-last-name form-control" id="form-last-name" value="<%= fname %>">
				                        </div>
				                        <div class="form-group">
				                        	<label class="sr-only" for="form-about-yourself">About yourself</label>
				                        	<input readonly=yes type="text" name="form-about-yourself" placeholder="Ваш логин в личном кабинете ОГУ" 
				                        				class="form-about-yourself form-control" id="form-about-yourself" value="<%= login %>">
				                        </div>
				                        <button type="button" class="btn btn-next">Далее</button>
				                    </div>
			                    </fieldset>
			                    
			                    <fieldset>
		                        	<div class="form-top">
		                        		<div class="form-top-left">
		                        			<h3>Шаг 2 / 3</h3>
		                            		<p>Данные для создания аккаунта:</p>
		                        		</div>
		                        		<div class="form-top-right">
		                        			<i class="fa fa-key"></i>
		                        		</div>
		                            </div>
		                            <div class="form-bottom">
				                        <div class="form-group"> <strong style='color:red'>Это будет ваш логин на portal.office.com</strong>
				                        	<label class="sr-only" for="form-email">e-mail</label>
				                        	<input readonly=yes type="text" name="form-email" placeholder="Email..." class="form-email form-control" id="form-email" value="<%= login %>@office.osu.ru">
				                        </div>
							Не менее 7 символов, + цифры, заглавные, спецсимволы...
				                        <div class="form-group">
				                    		<label class="sr-only" for="form-password">Пароль</label>
				                        	<input type="password" name="form-password" placeholder="Пароль" class="form-password form-control" id="form-password" >
				                        </div>
				                        <div class="form-group">
				                        	<label class="sr-only" for="form-repeat-password">Повторите пароль</label>
				                        	<input type="password" name="form-repeat-password" placeholder="Повторите пароль" 
				                        				class="form-repeat-password form-control" id="form-repeat-password">
				                        </div>
				                        <button type="button" class="btn btn-previous">Назад</button>
				                        <button type="button" class="btn btn-next">Далее</button>
				                    </div>
			                    </fieldset>
			                    
			                    <fieldset>
		                        	<div class="form-top">
		                        		<div class="form-top-left">
		                        			<h3>Step 3 / 3</h3>
		                            		<p>Создание аккаунта:</p>
		                        		</div>
		                        		<div class="form-top-right">
		                        			<i class="fa fa-twitter"></i>
		                        		</div>
		                            </div>
		                            <div class="form-bottom">
							<input type=hidden name=faculty value="<%= fac %>">	
							<input type=hidden name=dep value="<%= kaf %>">	
							<input type=hidden name=email value="<%= email %>">	
							<input type=hidden name= value="<%= fac %>">	
							<input type=hidden name=name value="<%= name %>">	
							<input type=hidden name=fname value="<%= fname %>">	
							<input type=hidden name=key value="<%= key %>">	
							<input type=hidden name=type value="<%= type %>">	
							<input type=hidden name=login value="<%= login %>">	
							<input type=hidden name=id value="<%= id %>">
							Укажите способы восставновления пароля	
				                        <div class="form-group">
				                        	<label class="sr-only" for="form-email2">e-mail2</label>
				                        	<input type="text" name="form-email2" placeholder="Личный Email..." class=" " id="form-email2" >
				                        </div>
				                        <div class="form-group">
				                        	<label class="sr-only" for="form-tel">e-mail</label>
				                        	<input  type="text" name="form-tel" placeholder="Сотовый телефон (+79xxxxxxxx)..." class="" id="form-tel" >
				                        </div>
				                        Учетная запись будет создана в течении 30 минут
							<button type="submit" class="btn">Создать заявку</button>
				                    </div>
			                    </fieldset>
		                    
		                    </form>
		                    
                        </div>
                    </div>
                </div>
            </div>
            
        </div>


        <!-- Javascript -->
        <script src="assets/js/jquery-1.11.1.min.js"></script>
        <script src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.backstretch.min.js"></script>
        <script src="assets/js/retina-1.1.0.min.js"></script>
        <script src="assets/js/scripts.js"></script>
        
        <!--[if lt IE 10]>
            <script src="assets/js/placeholder.js"></script>
        <![endif]-->
         </div>
    </body>

</html>