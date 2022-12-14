#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СпрашиватьПриЗакрытии=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("СпрашиватьОДемоВерсииПриЗакрытииСистемы", Ложь);
	ДемоВерсияССайта=КП_ОбщееСервер.КонстантаДополнительныеПараметрыПолучить("ЭтоДемоВерсияСистемы", Ложь);
	
	Если Параметры.Свойство("ВопросВТехПоддержку") И Параметры.ВопросВТехПоддержку Тогда
		РабочаяВерсия=Истина;
	Иначе
		Если ДемоВерсияССайта<>Неопределено И ДемоВерсияССайта Тогда
			РабочаяВерсия=Ложь;
		Иначе
			РабочаяВерсия=Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоВопросПриВыходе") И Параметры.ЭтоВопросПриВыходе Тогда
		Элементы.ЗакрытьФорму.Видимость=Истина;
	Иначе
		Элементы.ЗакрытьФорму.Видимость=Ложь;
	КонецЕсли;
	
	ПрочитатьНастройкиСервером();
	
	УстановитьДоступностьЭлементов();
	
	Элементы.ДекорацияСостояниеОбработки.Заголовок=НСтр("ru='Ожидание вопроса'; en='Waiting for the question';");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПереходНаСайтНажатие(Элемент)
	СтрокаСтраницыСайта="mailto:1c@analitica.ru";
	
	ЗапуститьПриложение(СтрокаСтраницыСайта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВопрос(Команда) 	
	
	ЗаписатьНастройкиСервером();
	
	Если ПустаяСтрока(ПараметрВопросРазработчикам) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Unknown text of the question. The message was not sent.';ru='Не указан текст вопроса. Сообщение не отправлено.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ПараметрЭлПочта) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Unknown addresses to answer. The message was not sent.';ru='Не указан адрес эл. почты для ответа. Сообщение не отправлено.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;
	
	Если Найти(ПараметрЭлПочта, "@")=0 ИЛИ Найти(ПараметрЭлПочта, ".")=0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Incorrect e-mail. The message was not sent.';ru='Указан некорректный адрес эл. почты. Сообщение не отправлено.'"), 60, КП_ОбщееКлиент.ЗаголовокДиалога());
		Возврат;
	КонецЕсли;

	Состояние(НСтр("en='Sending request through the developer website';ru='Отправка вопроса через сервер разработчика'"));
	
	Элементы.ДекорацияСостояниеОбработки.Заголовок=НСтр("ru='Отправка вопроса через сервер разработчика...'; en='Waiting for server replay';");
	
	ОбновитьОтображениеДанных();
	
	Элементы.ДекорацияСостояниеОбработки.Шрифт=Новый Шрифт(,,Истина);
	
	РезультатОтправки=ОтправитьВопросСервером();
	
	Если ПустаяСтрока(РезультатОтправки) Тогда
		
		Состояние(НСтр("en='Request successfully sent.';ru='Вопрос успешно отправлен.'"));
		Элементы.ДекорацияПереходНаСайт.Видимость=Ложь;
		Элементы.ДекорацияСостояниеОбработки.Заголовок=НСтр("ru='Вопрос отправлен'; en='Request sent';");
		Элементы.ДекорацияСостояниеОбработки.ЦветТекста=WebЦвета.ТемноЗеленый;
				
	Иначе
		//ошибка отправки
		Элементы.ДекорацияПереходНаСайт.Видимость=Истина;
		Элементы.ДекорацияСостояниеОбработки.Заголовок=НСтр("ru='Ошибка отправки вопроса'; en='Request sending error';")+": "+РезультатОтправки;
		Элементы.ДекорацияСостояниеОбработки.ЦветТекста=WebЦвета.ТемноКрасный;
		
	КонецЕсли;
	
	Элементы.ОтправитьВопрос.КнопкаПоУмолчанию=Ложь;
	
КонецПроцедуры
	
&НаСервере
Функция ОтправитьВопросСервером_cgi()
	
	СайтURL="analitica.ru";
	
	ПутьКСкриптуСайта="cgi-bin/sender_docflow.cgi";
	
	ВремКаталог=КаталогВременныхФайлов();
	ИмяЛокальногоФайла=ВремКаталог+"\tmp_file";
	
	СтрокаПараметров="";
	
	firm=КодировкаСтроки(ПараметрПредприятие);
	fio=КодировкаСтроки(ПараметрФИО);
	email=КодировкаСтроки(ПараметрЭлПочта);
	comments=КодировкаСтроки(ПараметрВопросРазработчикам);
	
	questions="";
	Если Элементы.ГруппаАнкета.Видимость Тогда
		//сформируем блок анкеты
		questions="&questions=";
		questions=questions+"Анкета пользователя: ";
		questions=questions+Символы.ПС+"Интерес к данному продукту: ";
		Если АнкетаПродуктИнтересен=0 Тогда
			questions=questions+"Не указано";
		ИначеЕсли АнкетаПродуктИнтересен=1 Тогда
			questions=questions+"Пока не понятно";
		ИначеЕсли АнкетаПродуктИнтересен=2 Тогда
			questions=questions+"Интересен";
		ИначеЕсли АнкетаПродуктИнтересен=3 Тогда
			questions=questions+"Не интересен";
		КонецЕсли;
		
		questions=questions+Символы.ПС+"Планируется приобретение: ";
		Если АнкетаПланируемПриобретение=0 Тогда
			questions=questions+"Не указано";
		ИначеЕсли АнкетаПланируемПриобретение=1 Тогда
			questions=questions+"Не планируется";
		ИначеЕсли АнкетаПланируемПриобретение=2 Тогда
			questions=questions+"В ближайшее время";
		ИначеЕсли АнкетаПланируемПриобретение=3 Тогда
			questions=questions+"В течение года";
		КонецЕсли;
		
		Если АнкетаКоммерческоеПредложение=1 Тогда
			questions=questions+Символы.ПС+"ВАЖНО: Требуется коммерческое предложение.";
		Иначе
			questions=questions+Символы.ПС+"Не требуется коммерческое предложение";
		КонецЕсли;
		
		questions=questions+Символы.ПС+Символы.ПС+"Скидка за заполнение анкеты";
		
		questions=questions+".";
		
	КонецЕсли;
	
	Если РабочаяВерсия Тогда
		subject="new question from KP UNF support";
		firstline=КодировкаСтроки("Новый вопрос на линию технической поддержки КП для УНФ");
	Иначе
		subject="new question from KP UNF demo";
		firstline=КодировкаСтроки("Новый вопрос разработчикам из демо-версии КП для УНФ");
		
	КонецЕсли;
	
	questions=КодировкаСтроки(questions);
	message_type=КодировкаСтроки("Вопрос разработчикам");
	message_sent_ok=КодировкаСтроки("Ok");
 	
	СтрокаПараметров="firm="+firm+"&fio="+fio+"&email="+email+"&comments="+comments+"&subject="+subject+"&firstline="+firstline+"&message_type="+"&message_sent_ok="+message_sent_ok+questions+"&key=732";
	СтрокаПараметров=Лев(СтрокаПараметров, 2000); //максимальная длина get запроса 
	
	ПолныйПутьКФайлу=СайтURL+"/"+ПутьКСкриптуСайта+"?"+СтрокаПараметров;
	
	Попытка
		ssl=Новый ЗащищенноеСоединениеOpenSSL();
		Сайт=Новый HTTPСоединение(СайтURL, ,,,,,ssl);
		Сайт.Получить(ПутьКСкриптуСайта+"?"+СтрокаПараметров, ИмяЛокальногоФайла);
		
		УдалитьФайлы(ИмяЛокальногоФайла);
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Ошибка доступа к сайту ';")+СайтURL+НСтр("ru=': ';")+ОписаниеОшибки());
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОтправитьВопросСервером()

	АдресСервера="analitica.ru";
		
	СтрокаПараметров="";
	
	firm=КодироватьДляURL(ПараметрПредприятие);
	fio=КодироватьДляURL(ПараметрФИО);
	email=КодироватьДляURL(ПараметрЭлПочта);
	text=КодироватьДляURL(ПараметрВопросРазработчикам);
	
	questions="";
	Если Элементы.ГруппаАнкета.Видимость Тогда
		//сформируем блок анкеты
		questions="&questions=";
		questions=questions+"Анкета пользователя: ";
		questions=questions+Символы.ПС+"Интерес к данному продукту: ";
		Если АнкетаПродуктИнтересен=0 Тогда
			questions=questions+"Не указано";
		ИначеЕсли АнкетаПродуктИнтересен=1 Тогда
			questions=questions+"Пока не понятно";
		ИначеЕсли АнкетаПродуктИнтересен=2 Тогда
			questions=questions+"Интересен";
		ИначеЕсли АнкетаПродуктИнтересен=3 Тогда
			questions=questions+"Не интересен";
		КонецЕсли;
		
		questions=questions+Символы.ПС+"Планируется приобретение: ";
		Если АнкетаПланируемПриобретение=0 Тогда
			questions=questions+"Не указано";
		ИначеЕсли АнкетаПланируемПриобретение=1 Тогда
			questions=questions+"Не планируется";
		ИначеЕсли АнкетаПланируемПриобретение=2 Тогда
			questions=questions+"В ближайшее время";
		ИначеЕсли АнкетаПланируемПриобретение=3 Тогда
			questions=questions+"В течение года";
		КонецЕсли;
		
		Если АнкетаКоммерческоеПредложение=1 Тогда
			questions=questions+Символы.ПС+"ВАЖНО: Требуется коммерческое предложение.";
		Иначе
			questions=questions+Символы.ПС+"Не требуется коммерческое предложение";
		КонецЕсли;
		
		questions=questions+Символы.ПС+Символы.ПС+"Скидка за заполнение анкеты";
		
		questions=questions+".";
		
	КонецЕсли;
	
	Если РабочаяВерсия Тогда
		subject="Новый вопрос о КП для УНФ";
		firstline=КодироватьДляURL("Новый вопрос на линию технической поддержки КП для УНФ");
	Иначе
		subject="Новый вопрос из демо-версии КП для УНФ";
		firstline=КодироватьДляURL("Новый вопрос разработчикам из демо-версии КП для УНФ");		
	КонецЕсли;
	
	questions=КодироватьДляURL(questions);
	message_type=КодироватьДляURL("Вопрос разработчикам");
 	
	СтрокаПараметров="firm="+firm+"&fio="+fio+"&email="+email+"&text="+text+"&subject="+subject+"&firstline="+firstline+"&message_type="+message_type+"&questions="+questions+"&key=732";
	СтрокаПараметров=Лев(СтрокаПараметров, 4096);	
				
	СтрокаОшибки="";
	
	Попытка
		ssl=Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
		Соединение = Новый HTTPСоединение(АдресСервера,,,,,, ssl);
		
		HttpЗапрос = Новый HTTPЗапрос("/my/sendmessage.php");
		HttpЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
		HttpЗапрос.Заголовки.Вставить("Content-type", "application/x-www-form-urlencoded");
		
		Результат=Соединение.ОтправитьДляОбработки(HttpЗапрос);
		Соединение=Неопределено;

		Если Результат.КодСостояния=200 Тогда
			ТекстРезультата=Результат.ПолучитьТелоКакСтроку();
			Если ПустаяСтрока(ТекстРезультата) Тогда
				Возврат "";
			Иначе
				Возврат ТекстРезультата;
			КонецЕсли;
			
		ИначеЕсли Результат.КодСостояния=400 Тогда
			СтрокаОшибки="Ответ не был получен. Код "+Результат.КодСостояния;
		Иначе
			СтрокаОшибки="Ошибка получения данных. Код "+Результат.КодСостояния;
		КонецЕсли;		
    
	Исключение
		СтрокаОшибки=КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
		
	Возврат СтрокаОшибки;
	
КонецФункции


Процедура УстановитьДоступностьЭлементов()
	
	Если РабочаяВерсия Тогда
		
		Элементы.ДекорацияЗаголовок.Заголовок=НСтр("ru='Спасибо за использование модуля ""Конструктор процессов для 1С:Управление нашей фирмой"".'; en='Thank you for using the subsystem ""Process Constructor"".';");
		Элементы.ДекорацияИнформация.Заголовок=НСтр("ru='Если у вас есть технические вопросы, пожалуйста обращайтесь:'; en='If you have any question please feel free to ask: ';");
		Элементы.СтрокаЭлПочта.Заголовок="Линия тех. поддержки";
		Элементы.СтрокаТелефоны.Видимость=Ложь;
		Элементы.ДекорацияЗадатьВопросТекст.Заголовок=НСтр("ru='Вы также можете задать вопрос в тех. поддержку прямо сейчас:'; en='You can ask question right now:';");
		СтрокаЭлПочта="support@analitica.ru";
		
		ТекущийПользователь=Пользователи.ТекущийПользователь();
		ПараметрФИО=СокрЛП(ТекущийПользователь);
		ОсновнаяОрганизация=КП_ОбщееСервер.ЗагрузитьНастройкуПользователя("НастройкиПользователя", "ОсновнаяОрганизация", , СокрЛП(ТекущийПользователь));
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
			ПараметрПредприятие=ОсновнаяОрганизация;
		КонецЕсли;
		
		Элементы.ДекорацияАнкета.Видимость=Ложь;

	Иначе
			
		Элементы.ДекорацияЗаголовок.Заголовок=НСтр("ru='Спасибо за ознакомление с демо-версией модуля ""Конструктор процессов для 1С:Управление нашей фирмой"".'; en='Thank you for reviewing the subsystem ""Process Constructor"" demo.';");
		Элементы.ДекорацияИнформация.Заголовок=НСтр("ru='Если у вас остались вопросы, пожалуйста обращайтесь:'; en='If you have any question please feel free to ask: ';");
		Элементы.СтрокаЭлПочта.Заголовок=НСтр("ru='Электронная почта'; en='E-mail;");
		//Элементы.ПараметрВопросРазработчикам.Заголовок="Вопрос разработчикам";
		Элементы.ДекорацияЗадатьВопросТекст.Заголовок=НСтр("ru='Вы также можете задать вопрос разработчикам прямо сейчас:'; en='You can ask question right now';");
		Элементы.СтрокаТелефоны.Видимость=Истина;
		
		СтрокаТелефоны="+7 495 005-16-53, +7 343 203-36-76";
		СтрокаЭлПочта="1c@kp-unf.ru";
		
		Элементы.ДекорацияАнкета.Видимость=Истина;
		
	КонецЕсли;
	
	Элементы.ГруппаАнкета.Видимость=Ложь; //может быть включена в демо-версии отдельной гиперссылкой

КонецПроцедуры

Функция КодировкаСтроки(ИсходнаяСтрока)
	НоваяСтрока=СокрЛП(ИсходнаяСтрока);
	НоваяСтрока=СтрЗаменить(НоваяСтрока, " ", "%20");
	
	Возврат НоваяСтрока;
	//Возврат URLEncode(ИсходнаяСтрока);
	
КонецФункции

Функция КодироватьДляURL(Стр) Экспорт
	
	Длина=СтрДлина(Стр);
	Итог="";
	Для Н=1 По Длина Цикл
		Знак=Сред(Стр,Н,1);
		Код=КодСимвола(Знак);
		
		если ((Знак>="a")и(Знак<="z")) или
			 ((Знак>="A")и(Знак<="Z")) или
			 ((Знак>="0")и(Знак<="9")) тогда
			Итог=Итог+Знак;
		Иначе
			Если (Код>=КодСимвола("А"))И(Код<=КодСимвола("п")) Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(208,16)+"%"+ПреобразоватьвСистему(144+Код-КодСимвола("А"),16);
			ИначеЕсли (Код>=КодСимвола("р"))И(Код<=КодСимвола("я")) Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(209,16)+"%"+ПреобразоватьвСистему(128+Код-КодСимвола("р"),16);
			ИначеЕсли (Знак="ё") Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(209,16)+"%"+ПреобразоватьвСистему(145,16);
			ИначеЕсли (Знак="Ё") Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(208,16)+"%"+ПреобразоватьвСистему(129,16);
			Иначе
				Итог=Итог+"%"+ПреобразоватьвСистему(Код,16);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Итог;
	
КонецФункции


Функция ПреобразоватьвСистему(Число10,система)
	
	Если система > 36 или система < 2 тогда
		Сообщить("Выбранная система исчисления не поддерживается");
		Возврат -1;
	КонецЕсли;
	
	СтрокаЗначений = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	СтрокаСистема = "";
	Пока Число10 > 0 цикл
		РезДеления = Число10/система;
		ЧислоСистема = цел(РезДеления);
		остатокОтДеления = Число10 - система*(ЧислоСистема);
		СтрокаСистема = сред(СтрокаЗначений,остатокОтДеления+1,1)+ СтрокаСистема;
		Число10 = ?(ЧислоСистема=0,0,РезДеления); 
	КонецЦикла;
	
	Нечётное = стрДлина(СтрокаСистема) - цел(стрДлина(СтрокаСистема)/2)*2;
	Если Нечётное тогда
		СтрокаСистема = "0"+СтрокаСистема;
	КонецЕсли;

	Возврат СтрокаСистема;
	
КонецФункции

&НаКлиенте
Процедура ПараметрЭлПочтаПриИзменении(Элемент)
		
	Если ПустаяСтрока(ПараметрЭлПочта) Тогда
		Элементы.ДекорацияОтветНаЭлПочту.Заголовок="Ответ будет выслан Вам на электронную почту";
		
	Иначе
		Элементы.ДекорацияОтветНаЭлПочту.Заголовок="Ответ будет выслан Вам на электронную почту "+СокрЛП(ПараметрЭлПочта);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиСервером()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ФормаОтправкиРазработчикам", "ПараметрЭлПочта", ПараметрЭлПочта);	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ФормаОтправкиРазработчикам", "ПараметрПредприятие", ПараметрПредприятие);	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ФормаОтправкиРазработчикам", "ПараметрФИО", ПараметрФИО);	
	
	//запишем отказ от вопроса при выходе из системы, так как пользователь уже открывал эту форму
	КП_ОбщееСервер.КонстантаДополнительныеПараметрыУстановить("СпрашиватьОДемоВерсииПриЗакрытииСистемы", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиСервером()
	
	Если РабочаяВерсия Тогда
		ПараметрЭлПочта=ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ФормаОтправкиРазработчикам", "ПараметрЭлПочта");	
		ПараметрПредприятие=ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ФормаОтправкиРазработчикам", "ПараметрПредприятие");	
		ПараметрФИО=ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ФормаОтправкиРазработчикам", "ПараметрФИО");	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАнкетаНажатие(Элемент)
	Элементы.ГруппаАнкета.Видимость=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВопросРазработчикамПриИзменении(Элемент)
	Элементы.ОтправитьВопрос.КнопкаПоУмолчанию=Истина;
КонецПроцедуры

#КонецОбласти
