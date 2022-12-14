
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СоздатьСайт(ВхПараметры, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ДанныеСайта = ПолучитьДанныеСозданияСайта(ВхПараметры);
	
	Если ТипЗнч(ДанныеСайта)= Тип("Соответствие") Тогда
		
		ЗаписатьДанныеСайта(ВхПараметры, ДанныеСайта);
		
		СайтСоздан = ДанныеСайта.Получить("ready");
		ОжиданиеСозданияСайта = ДанныеСайта.Получить("waiting");
		
		ВхПараметры.Вставить("СайтСоздан", СайтСоздан);
		ВхПараметры.Вставить("ОжиданиеСозданияСайта", ОжиданиеСозданияСайта);
		
	ИначеЕсли ТипЗнч(ДанныеСайта)= Тип("Структура") Тогда
		ВхПараметры.Вставить("Ошибка", ДанныеСайта.Ошибка);
	Иначе
		ВхПараметры.Вставить("Ошибка", ДанныеСайта);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ВхПараметры, ФоновоеЗаданиеАдресХранилища);
	
КонецПроцедуры

Функция ПолучитьДанныеСозданияСайта(ВхПараметры) Экспорт

	ТипСайта = ВхПараметры.ТипСайта;
	ДанныеАвторизации = ДанныеДляАвторизации();
	Если ТипСайта=1 Тогда
		appID = 1;
	ИначеЕсли ТипСайта=2 Тогда
		appID = 10;
	ИначеЕсли ТипСайта=3 Тогда
		appID = 2;
	ИначеЕсли ТипСайта=4 Тогда
	    appID = 11;
	КонецЕсли;
	АдресЗапроса= ДанныеАвторизации.Получить("АдресЗапроса");
	Boundary = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");	
	ContentType = "multipart/form-data; charset=UTF-8; boundary=" + Boundary;
	ТекстОтправки = "";
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "partner", 	ДанныеАвторизации.Получить("partner"), Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "code", 	ДанныеАвторизации.Получить("code"), Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "host", 	ВхПараметры.АдресСайта, Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "action", 	"host_install", Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "email", 	ВхПараметры.EmailРегистрацииСайта, Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "appID", 	appID, Boundary);
	Если ВхПараметры.Свойство("desID") Тогда
		ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "desID",ВхПараметры.desID, Boundary);
	КонецЕсли;
	
	СтруктураДанныхСоздания = Новый Структура;
	СтруктураДанныхСоздания.Вставить("ТелоЗапроса", ТекстОтправки);
	
	СтруктураДанныхСоздания.Вставить("АдресЗапроса",
		ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресЗапроса));
		
	ТекстОшибки = "";
	ДанныеСтрока = ПолучитьДанныеЗапросом("POST", СтруктураДанныхСоздания.ТелоЗапроса, СтруктураДанныхСоздания.АдресЗапроса, Новый Структура,
		ContentType,,,ТекстОшибки);
		
	Если ТекстОшибки<>"" Тогда
		Возврат ТекстОшибки;
	КонецЕсли;
		
	Если Лев(ДанныеСтрока,6) = "<html>" Тогда
		ТекстОшибки = Сред(ДанныеСтрока, СтрНайти(ДанныеСтрока, "<title>")+7, СтрНайти(ДанныеСтрока, "</title>")-СтрНайти(ДанныеСтрока, "<title>")-7);
		ДанныеСайтаСтруктура = Новый Структура("Ошибка", ТекстОшибки);
		Возврат ДанныеСайтаСтруктура;
	ИначеЕсли Лев(ДанныеСтрока,1) = "{" Тогда
		ДанныеСайта = ПрочитатьРеквизитJSON(ДанныеСтрока, "result");
		Если ТипЗнч(ДанныеСайта)= Тип("Соответствие") Тогда
			
			Возврат ДанныеСайта;
		ИначеЕсли ТипЗнч(ДанныеСайта) = Тип("Булево") Тогда
			ДанныеОшибки = ПрочитатьРеквизитJSON(ДанныеСтрока, "errors");
			Если ТипЗнч(ДанныеОшибки)=Тип("Массив") Тогда
				Для каждого стрОшибки Из ДанныеОшибки Цикл
					ТекстОшибки = ТекстОшибки + стрОшибки + Символы.ПС;
				КонецЦикла;
			КонецЕсли;
			Возврат ТекстОшибки;
		Иначе
			ТекстОшибки = ДанныеСайта.Получить("errors");
			Возврат ТекстОшибки;
		КонецЕсли;
	Иначе
		Возврат ДанныеСтрока;
	КонецЕсли;
	
КонецФункции

Процедура СоздатьСайтПродолжить(ВхПараметры, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ЗаписатьКонтактнуюИнформацию(ВхПараметры.АдресСайта, ВхПараметры.ПарольСайта, ВхПараметры.ОсновнаяОрганизация,
		ВхПараметры.ТипСайта);
	
	Если ВхПараметры.ТипСайта=4 Тогда
		
		ЗначениеОтображатьОстатки = ?(ВхПараметры.ВыгружатьОстатки, "true", "false"); 
		// 1-отображать остатки, товары без остатка будут не видны
		// 0 - видны все товары, остаток отображается в режиме редактирования
		ЗаписатьПоляСайта(ВхПараметры.АдресСайта, ВхПараметры.ПарольСайта, "dlya_vstavki",
			"emarket_set_invisible_when_import", ЗначениеОтображатьОстатки);
		
		ЗначениеОтображатьХарактеристики = "true";
		// 1-отображать остатки, товары без остатка будут не видны
		// 0 - видны все товары, остаток отображается в режиме редактирования
		ЗаписатьПоляСайта(ВхПараметры.АдресСайта, ВхПараметры.ПарольСайта, "dlya_vstavki", "new_offers_import",
			ЗначениеОтображатьХарактеристики);
		
		СоздатьУзелОбменаССайтом(ВхПараметры,
			ВхПараметры.АдресСайта, 
			ВхПараметры.IDсайта, 
			ВхПараметры.ПарольСайта);
			
		ЗапуститьОбменССайтом(ВхПараметры.IDсайта);
		
	ИначеЕсли ВхПараметры.ТипСайта=3 И ВхПараметры.ЗаписьНаУслуги Тогда

		СоздатьУзелОбменаССайтом(ВхПараметры,
			ВхПараметры.АдресСайта, 
			ВхПараметры.IDсайта, 
			ВхПараметры.ПарольСайта);
			
		ЗапуститьОбменССайтом(ВхПараметры.IDсайта);
		
	КонецЕсли;
	
	ВхПараметры.Вставить("ОбменВыполнен", Истина);
	ПоместитьВоВременноеХранилище(ВхПараметры, ФоновоеЗаданиеАдресХранилища);
	
КонецПроцедуры

Функция ДанныеДляАвторизации() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("partner", "Test1C");
	Результат.Вставить("code", "26a63f89a737125b418492ff70ae1567");
	Результат.Вставить("АдресЗапроса", "https://gate.umi.ru/partnerapi");
					 
	Возврат Результат;
	
КонецФункции

Процедура СоздатьУзелОбменаССайтом(ВхПараметры, АдресСайта, IDсайта, Пароль="") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОбменУправлениеНебольшойФирмойСайт.Ссылка КАК ПланОбмена
	|ИЗ
	|	ПланОбмена.ОбменУправлениеНебольшойФирмойСайт КАК ОбменУправлениеНебольшойФирмойСайт
	|ГДЕ
	|	ОбменУправлениеНебольшойФирмойСайт.Код = &IDсайта";
	
	Запрос.УстановитьПараметр("IDсайта", IDсайта);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ПланОбменаСайт = ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.СоздатьУзел();
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПланОбменаСайт = Выборка.ПланОбмена.ПолучитьОбъект();
		КонецЦикла;
	КонецЕсли;
	
	ПланОбменаСайт.АдресСайта = "https://"+АдресСайта+"/admin/exchange/autoimport/";
	ПланОбменаСайт.ВыгружатьНаСайт = Истина;
	
	Если ВхПараметры.ТипСайта=4 Тогда
		ПланОбменаСайт.ВидыЦен.Очистить();
		НовыйВидЦен = ПланОбменаСайт.ВидыЦен.Добавить();
		НовыйВидЦен.ВидЦен = ВхПараметры.ВидЦен;
	
		ПланОбменаСайт.ВыгружатьКартинки			= Истина;
		
		ПланОбменаСайт.ВыгружатьОстаткиПоСкладам	= ВхПараметры.ВыгружатьОстатки;
		ПланОбменаСайт.ОбменЗаказами				= Истина;
		ПланОбменаСайт.ОрганизацияДляПодстановкиВЗаказы = ВхПараметры.ОсновнаяОрганизация;
		ПланОбменаСайт.СпособИдентификацииКонтрагентов = Перечисления.СпособыИдентификацииКонтрагентов.СоздаватьИскатьПоТелефонуEmail;
		ПланОбменаСайт.ОтборГруппыКатегорииНоменклатуры = ВхПараметры.ОтборКатегорииГруппыПереключатель;
		
		ТаблицаКаталогов = ХранилищеСистемныхНастроек.Загрузить("ТаблицаКаталоговСозданияСайта");
		Если ТаблицаКаталогов.Количество() > 0 Тогда
			ПланОбменаСайт.ОбменТоварами = Истина;
			ПланОбменаСайт.СохраненнаяТаблицаКаталогов = Новый ХранилищеЗначения(ТаблицаКаталогов);
		КонецЕсли;
	КонецЕсли;
	ПланОбменаСайт.ИмяПользователя				= ВхПараметры.ИмяСайта;
	ПланОбменаСайт.Код							= IDсайта;
	ПланОбменаСайт.Наименование					= НСтр("ru = 'Обмен товарами и заказами с '") + АдресСайта;
	ПланОбменаСайт.ВыполнятьПолнуюВыгрузкуПринудительно = ПланОбменаСайт.ЭтоНовый();
	
	ПланОбменаСайт.ПротоколОбменаCMS = Перечисления.ПротоколыОбменаCMS.UMI;
	
	ПланОбменаСайт.ПереходАдресСайта = ВхПараметры.АдресСайта;
	ПланОбменаСайт.ПереходURLАдминЗоны = ВхПараметры.СсылкаАдминЗоны;
	
	Если ВхПараметры.ЗаписьНаУслуги Тогда
		
		ПланОбменаСайт.ИдентификаторКаталогаУслуг = Новый УникальныйИдентификатор;
		
		ПланОбменаСайт.ОбменЗаписьНаУслуги = Истина;
		ПланОбменаСайт.ВидЦенУслуг = ВхПараметры.ВидЦен;
		ПланОбменаСайт.ВыгружатьДнейГрафика = 14;
	КонецЕсли;
	
	Попытка
		
		ПланОбменаСайт.Записать();
		
		Если Пароль<>"" Тогда
			УстановитьПривилегированныйРежим(Истина);
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ПланОбменаСайт.Ссылка, Пароль);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиЗаписьНаУслуги.ИсточникЗаписи КАК ИсточникЗаписи,
	|	НастройкиЗаписьНаУслуги.Услуга КАК Услуга,
	|	НастройкиЗаписьНаУслуги.Ресурс КАК Ресурс,
	|	НастройкиЗаписьНаУслуги.Длительность КАК Длительность,
	|	НастройкиЗаписьНаУслуги.УзелОбмена КАК УзелОбмена
	|ИЗ
	|	РегистрСведений.НастройкиЗаписьНаУслуги КАК НастройкиЗаписьНаУслуги
	|ГДЕ
	|	НастройкиЗаписьНаУслуги.УзелОбмена = ЗНАЧЕНИЕ(ПланОбмена.ОбменУправлениеНебольшойФирмойСайт.ПустаяСсылка)
	|	И НастройкиЗаписьНаУслуги.ИсточникЗаписи = ЗНАЧЕНИЕ(Перечисление.ЗаписьНаУслугиИсточник.Сайт)";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МЗ = РегистрыСведений.НастройкиЗаписьНаУслуги.СоздатьМенеджерЗаписи();
		
		МЗ.ИсточникЗаписи = Выборка.ИсточникЗаписи;
		МЗ.Услуга = Выборка.Услуга;
		МЗ.Ресурс = Выборка.Ресурс;
		МЗ.Длительность = Выборка.Длительность;
		
		МЗ.Прочитать();
		МЗ.УзелОбмена = ПланОбменаСайт.Ссылка;
		
		МЗ.Записать(Истина);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ПланОбменаСайт.Ссылка, Пароль);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаписатьПоляСайта(АдресСайта, ПарольСайта, РазделСайта, ИмяПоля, ЗначениеПоля) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗначениеПоля) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеАвторизации = ДанныеДляАвторизации();
	АдресЗапроса= ДанныеАвторизации.Получить("АдресЗапроса");
	
	Boundary = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");	
	ContentType = "multipart/form-data; charset=UTF-8; boundary=" + Boundary;
	ТекстОтправки = "";
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "partner", 	ДанныеАвторизации.Получить("partner"), Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "code", 	ДанныеАвторизации.Получить("code"), Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "host", 	АдресСайта, Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "action", 	"put_config_fields", Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "password", ПарольСайта, Boundary);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "Fields["+РазделСайта+"|"+ИмяПоля+"]", ЗначениеПоля, Boundary);
	
	СтруктураДанныхСоздания = Новый Структура;
	СтруктураДанныхСоздания.Вставить("ТелоЗапроса", ТекстОтправки);
	
	СтруктураДанныхСоздания.Вставить("АдресЗапроса",
		ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресЗапроса));
		
	ТекстОшибки = "";
	ДанныеСтрока = ПолучитьДанныеЗапросом("POST", СтруктураДанныхСоздания.ТелоЗапроса,
		СтруктураДанныхСоздания.АдресЗапроса, Новый Структура, ContentType, , , ТекстОшибки);
		
	Если ТекстОшибки="" Тогда
		ДанныеУспешноЗаписаны = ПрочитатьРеквизитJSON(ДанныеСтрока, "result");
		Если ДанныеУспешноЗаписаны Тогда
			
		Иначе
			ТекстОшибки = ПрочитатьРеквизитJSON(ДанныеСтрока, "errors");
			Если ТипЗнч(ТекстОшибки)=Тип("Массив") Тогда
				Для каждого стр Из ТекстОшибки Цикл
				    Сообщить(стр);
				КонецЦикла;
			Иначе
				Сообщить(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеЗапросом(HTTPМетод, ТелоЗапроса, АдресЗапроса, ЗаголовкиЗапроса, 
	ContentType="", РазмерФайлаОтправки="", ИмяФайлаОтправки="", ТекстОшибки="")
	
	HTTPСоединение = Новый HTTPСоединение(
	АдресЗапроса.Хост,
	АдресЗапроса.Порт,,,,
	1800,
	ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение()
	);
	
	Если ContentType="" Тогда
		ContentType = "application/json;charset=utf-8";
	КонецЕсли;
	
	ЗапросHTTP = Новый HTTPЗапрос(АдресЗапроса.ПутьНаСервере);
	ЗапросHTTP.Заголовки["Cache-Control"]	= "no-cache";
	ЗапросHTTP.Заголовки["Content-type"]	= ContentType;
	Для каждого стр Из ЗаголовкиЗапроса Цикл
		ЗапросHTTP.Заголовки[стр.Ключ]	= стр.Значение;
	КонецЦикла;
	
	Если ТипЗнч(ТелоЗапроса)=Тип("Строка") Тогда
		ЗапросHTTP.УстановитьТелоИзСтроки(ТелоЗапроса,"UTF-8",ИспользованиеByteOrderMark.НеИспользовать);
	ИначеЕсли ТипЗнч(ТелоЗапроса)=Тип("ДвоичныеДанные") Тогда
		ЗапросHTTP.УстановитьТелоИзДвоичныхДанных(ТелоЗапроса);
	ИначеЕсли ИмяФайлаОтправки<>"" Тогда
		ЗапросHTTP.УстановитьИмяФайлаТела(ИмяФайлаОтправки);
	Иначе
		
	КонецЕсли; 
	
	Попытка
		Если HTTPМетод="GET" Тогда
		    ОтветHTTP = HTTPСоединение.Получить(ЗапросHTTP);
		ИначеЕсли HTTPМетод="POST" Тогда
			ОтветHTTP = HTTPСоединение.ОтправитьДляОбработки(ЗапросHTTP);
		ИначеЕсли HTTPМетод="PUT" Тогда
			ОтветHTTP = HTTPСоединение.Записать(ЗапросHTTP);
		ИначеЕсли HTTPМетод="DELETE" Тогда	
			ОтветHTTP = HTTPСоединение.Удалить(ЗапросHTTP);
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Если СтрНайти(ТекстОшибки, "Couldn't resolve host name")<>0 Тогда
		    ТекстОшибки = НСтр("ru = 'Ошибка: Не могу подключиться к интернету!'");
		КонецЕсли;
		Возврат "";
	КонецПопытки;
	
	Если ОтветHTTP.КодСостояния<>200 Тогда
		Сообщить(ОтветHTTP.КодСостояния);
	КонецЕсли;

	ОтветКакСтрока = ОтветHTTP.ПолучитьТелоКакСтроку();
	Возврат ОтветКакСтрока;	
	
КонецФункции

Функция ПрочитатьРеквизитJSON(ДанныеСтрока, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(ДанныеСтрока) Тогда
		Возврат 0;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеСтрока);
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);
	РеквизитЗначение = Результат.Получить(ИмяРеквизита);
	
	Возврат РеквизитЗначение;
	
КонецФункции

Процедура ЗапуститьОбменССайтом(КодУзлаОбмена)
	
	УзелОбмена = ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.НайтиПоКоду(КодУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(УзелОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ФункциональнаяОпцияИспользоватьОбменССайтами.Установить(Истина);
	
	ОбменССайтом.ВыполнитьОбмен(УзелОбмена, НСтр("ru = 'Обмен полный при создании сайта'"), Ложь);

КонецПроцедуры

Процедура ЗаписатьДанныеСайта(ВхПараметры, РезультатСозданияСайта)
	
	ПолученныйАдресСайта = РезультатСозданияСайта.Получить("host");
	IDсайта = РезультатСозданияСайта.Получить("id");
	ЛогинСайта = РезультатСозданияСайта.Получить("login");
	ПарольСайта = РезультатСозданияСайта.Получить("password");
	СсылкаАдминЗоны	= РезультатСозданияСайта.Получить("autologinUrl");
	
	НовСтр = РегистрыСведений.ДанныеСайта.СоздатьМенеджерЗаписи();
	НовСтр.Организация	= ВхПараметры.ОсновнаяОрганизация;
	НовСтр.АдресСайта	= ВхПараметры.АдресСайта;
	НовСтр.IDсайта		= IDсайта;
	НовСтр.ТипСайта		= ВхПараметры.ТипСайта;
	НовСтр.EMail		= ВхПараметры.EmailРегистрацииСайта;
	НовСтр.URLАдминЗоны	= СсылкаАдминЗоны;
	НовСтр.ПарольСайта	= ПарольСайта;
	НовСтр.СайтСоздан	= Истина;
	
	Попытка
		НовСтр.Записать(Истина);
	Исключение
		ВхПараметры.Вставить("Ошибка", ОписаниеОшибки());
	КонецПопытки;
	
	Константы.СайтСоздан.Установить(Истина);
	
	ВхПараметры.Вставить("IDсайта",		IDсайта);
	ВхПараметры.Вставить("АдресСайта",	ПолученныйАдресСайта);
	ВхПараметры.Вставить("ЛогинСайта",	ЛогинСайта);
	ВхПараметры.Вставить("ПарольСайта",	ПарольСайта);
	ВхПараметры.Вставить("СсылкаАдминЗоны",СсылкаАдминЗоны);
	
КонецПроцедуры

Процедура ЗаписатьКонтактнуюИнформацию(АдресСайта, ПарольСайта, ОсновнаяОрганизация, ТипСайта)

	ФактАдресОрганизации = УправлениеНебольшойФирмойСервер.ПолучитьКонтактнуюИнформацию(ОсновнаяОрганизация, 
	Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	
	ТелефонОрганизации = УправлениеНебольшойФирмойСервер.ПолучитьКонтактнуюИнформацию(ОсновнаяОрганизация, 
	Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	
	ФаксОрганизации = УправлениеНебольшойФирмойСервер.ПолучитьКонтактнуюИнформацию(ОсновнаяОрганизация, 
	Справочники.ВидыКонтактнойИнформации.ФаксОрганизации);
	
	EmailОрганизации = УправлениеНебольшойФирмойСервер.ПолучитьКонтактнуюИнформацию(ОсновнаяОрганизация, 
	Справочники.ВидыКонтактнойИнформации.EmailОрганизации);
	
	SkypeОрганизации = УправлениеНебольшойФирмойСервер.ПолучитьКонтактнуюИнформацию(ОсновнаяОрганизация, 
		Справочники.ВидыКонтактнойИнформации.НайтиПоРеквизиту("Тип", Перечисления.ТипыКонтактнойИнформации.Skype, ,ОсновнаяОрганизация));
		
	НаименованиеОрганизации = ОсновнаяОрганизация.Наименование;
		
		
	Если ТипСайта=4 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "imya_i_familiya",НаименованиеОрганизации);
		
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", 		ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "address", 	ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", 	ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 3 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", 		ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "address", 	ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", 	ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 2 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone",	ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 1 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "address", ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "fax", ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "skype", SkypeОрганизации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПараметрВТелоЗапроса(ТекстОтправки, ИмяПараметра, ЗначениеПараметра, Boundary)
	
	Если ТекстОтправки="" Тогда
		ДобавитьСтрокуССразделителем(ТекстОтправки, "--" + Boundary);
	КонецЕсли;
	
	ДобавитьСтрокуССразделителем(ТекстОтправки, "Content-disposition: form-data; name="+ИмяПараметра+"" + Символы.ПС);
	ДобавитьСтрокуССразделителем(ТекстОтправки, ЗначениеПараметра);
	ДобавитьСтрокуССразделителем(ТекстОтправки, "--" + Boundary);
	
КонецПроцедуры

Процедура ДобавитьСтрокуССразделителем(НачСтрока, добавитьТекст)
	
	НачСтрока = НачСтрока + добавитьТекст + Символы.ПС;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
