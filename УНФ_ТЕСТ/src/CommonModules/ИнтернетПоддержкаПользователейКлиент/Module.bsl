///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейКлиент.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет подключение к сервису Интернет-поддержки: ввод данных
// аутентификации (логина и пароля) для подключения к сервисам
// Интернет-поддержки.
// При успешном завершении возвращается введенный логин через
// объект ОписаниеОповещения.
//
// Параметры:
//	ОповещениеОЗавершении - ОписаниеОповещения - обработчик оповещения о
//		завершении. В обработчик оповещения возвращается значение:
//			Неопределено - при нажатии пользователем кнопки Отмена;
//			Структура, при успешном вводе логина и пароля.
//			Поля структуры:
//				* Логин - Строка - введенный логин;
//	ВладелецФормы - ФормаКлиентскогоПриложения - владелец формы подключения
//		Интернет-поддержки. Т.к. форма подключения Интернет-поддержки открывается
//		в режиме "Блокировать окно владельца", рекомендуется заполнять
//		значение этого параметра;
//
Процедура ПодключитьИнтернетПоддержкуПользователей(
	ОповещениеОЗавершении = Неопределено,
	ВладелецФормы = Неопределено) Экспорт

	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда

		ОповещениеАвторизацияНедоступна = Новый ОписаниеОповещения(
			"ПриНедоступностиПодключенияИПП",
			ЭтотОбъект,
			ОповещениеОЗавершении);

		ПоказатьПредупреждение(
			ОповещениеАвторизацияНедоступна,
			НСтр("ru = 'Использование Интернет-поддержки пользователей недоступно при работе в модели сервиса.'"));
		Возврат;
		
	КонецЕсли;
	
	// Проверить права пользователя для интерактивной авторизации.
	Если Не ДоступноПодключениеИнтернетПоддержки() Тогда
		
		ОповещениеАвторизацияНедоступна = Новый ОписаниеОповещения(
			"ПриНедоступностиПодключенияИПП",
			ЭтотОбъект,
			ОповещениеОЗавершении);
		
		ПоказатьПредупреждение(
			ОповещениеАвторизацияНедоступна,
			НСтр("ru = 'Недостаточно прав для подключения Интернет-поддержки пользователей. Обратитесь к администратору.'"));
		Возврат;
		
	КонецЕсли;
	
	// Открыть форму подключения ИПП.
	ОткрытьФорму("ОбщаяФорма.ПодключениеИнтернетПоддержки",
		,
		ВладелецФормы,
		,
		,
		,
		ОповещениеОЗавершении);
	
КонецПроцедуры

// Открывает страницу Портала 1С:ИТС для отправки сообщения в службу
// технической поддержки.
// В параметрах метода на страницу передаются данные заполнения.
//
// Параметры:
//	Тема - Строка - тема сообщения;
//	Тело - Строка - тело сообщения;
//	Получатель - Строка - условное имя получателя сообщения. Возможные значения:
//		- "webIts" - соответствует адресам "webits-info@1c.ru" и "webits-info@1c.ua",
//			необходимый адрес выбирается в соответствии с настройками доменной зоны
//			серверов Интернет-поддержки;
//		- "taxcom" - соответствует адресу "taxcom@1c.ru";
//		- "backup" - соответствует адресу "support.backup@1c.ru";
//	Вложения - Массив из Структура - массив значений типа Структура, файлы вложений.
//		Важно: допускаются только текстовые вложения (*.txt);
//		Поля структуры элемента вложения:
//			* Представление - Строка - представление вложения. Например:
//				"Вложение 1.txt";
//			Одно из полей:
//			* ИмяФайла - Строка - полное имя файла вложения;
//			* Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
//			* Текст - Строка - текст вложения;
//		К вложениям автоматически добавляется техническая информация о программе;
//	ОповещениеОЗавершении - ОписаниеОповещения - метод, в который должен быть
//		передан результат отправки сообщения. В метод передается значение типа
//		Булево: Истина, данные сообщения переданы успешно,
//			Ложь - в противном случае.
//
Процедура ОтправитьСообщениеВСлужбуТехническойПоддержки(
	Тема,
	Тело,
	Получатель = "webIts",
	Вложения = Неопределено,
	ОповещениеОЗавершении = Неопределено) Экспорт

	ОтправитьСообщениеВТехПоддержку(
		Тема,
		Тело,
		Получатель,
		Вложения,
		Новый Структура("ОповещениеОЗавершении", ОповещениеОЗавершении));

КонецПроцедуры

// Определяет, доступно ли текущему пользователю выполнение интерактивного
// подключения Интернет-поддержки в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - интерактивное подключение доступно,
//		Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	Возврат ПараметрыРаботыКлиента.ДоступноПодключениеИнтернетПоддержки;
	
КонецФункции

// Возвращает настройки соединения с серверами Интернет-поддержки.
//
// Возвращаемое значение:
//	Структура - настройки соединения. Поля структуры:
//		* УстанавливатьПодключениеНаСервере - Булево - Истина, если подключение
//			устанавливается на сервере 1С:Предприятие;
//		* ТаймаутПодключения - Число - таймаут подключения к серверам в секундах;
//		* ДоменРасположенияСерверовИПП - Число - если 0, устанавливать подключение
//			к серверам ИПП в доменной зоне 1c.ru, если 1 - в доменной зоне 1c.eu.
//
Функция НастройкиСоединенияССерверами() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнтернетПоддержкаПользователей;
	Результат = Новый Структура("ДоменРасположенияСерверовИПП");
	ЗаполнитьЗначенияСвойств(Результат, ПараметрыРаботыКлиента);
	Результат.Вставить("УстанавливатьПодключениеНаСервере", Истина);
	Результат.Вставить("ТаймаутПодключения"               , 30);
	Возврат Результат;
	
КонецФункции

#Область ПереходПоСсылкеНаПортал

// Открывает страницу сайта, система аутентификации которого интегрирована с
// Порталом 1С:ИТС.
// В зависимости от текущего режима работы информационной базы и наличия у
// текущего пользователя информационной базы соответствующих прав
// страница сайта может быть открыта с учетными данными пользователя Портала 1С:ИТС,
// для которого подключена Интернет-поддержка.
//
// Параметры:
//  URLСтраницыСайта - Строка - URL страницы сайта;
//  ЗаголовокОкна - Строка - заголовок окна для методов:
//      - ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу()
//      - ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(),
//        если используется.
//
Процедура ОткрытьСтраницуИнтегрированногоСайта(URLСтраницыСайта, ЗаголовокОкна = "") Экспорт
	
	Состояние(, , НСтр("ru = 'Пожалуйста, подождите...'"));
	РезультатПолученияURL = ИнтернетПоддержкаПользователейВызовСервера.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(URLСтраницыСайта);
	Состояние();
	
	Если Не ПустаяСтрока(РезультатПолученияURL.КодОшибки) И РезультатПолученияURL.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
		ПоказатьОповещениеПользователя(
			,
			,
			НСтр("ru = 'Ошибка входа на Портал 1С:ИТС.
				|Подробнее см. в журнале регистрации.'"),
			БиблиотекаКартинок.Ошибка32);
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(
		РезультатПолученияURL.URL,
		ЗаголовокОкна,
		СтандартнаяОбработка);
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу(
		РезультатПолученияURL.URL,
		ЗаголовокОкна,
		СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		// Открытие Интернет-страницы стандартным способом.
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(РезультатПолученияURL.URL);
	КонецЕсли;
	
КонецПроцедуры

// Открывает главную страницу Портала.
//
Процедура ОткрытьГлавнуюСтраницуПортала() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Портал 1С:ИТС'"));
	
КонецПроцедуры

// Открывает страницу Портала для регистрации нового пользователя.
//
Процедура ОткрытьСтраницуРегистрацииНовогоПользователя() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
			"/registration",
			НастройкиСоединенияССерверами()),
		НСтр("ru = 'Регистрация'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийПриложения

// Реализует обработку события ПередНачаломРаботыСистемы() клиентского
// приложения. Необходимо реализовать вызов метода из
// МодульУправляемогоПриложения.ПередНачаломРаботыСистемы()
// и МодульОбычногоПриложения.ПередНачаломРаботыСистемы().
//
// Обработчик, вызываемый перед началом работы системы.
//
Процедура ПередНачаломРаботыСистемы() Экспорт

	ПараметрыПередНачаломРаботы =
		ИнтернетПоддержкаПользователейВызовСервера.ПередНачаломРаботыСистемы(ПараметрыКлиента());
	
	// Подключение обработчика запроса настроек клиента лицензирования
	Если ПараметрыПередНачаломРаботы.ДоступнаРаботаСНастройкамиКлиентаЛицензирования Тогда
		Попытка
			КлиентЛицензированияКлиент.ПодключитьОбработчикБИПДляЗапросаНастроекКлиентаЛицензирования();
		Исключение
			ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось подключить обработчик запроса настроек клиента лицензирования.
						|%1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки;
	КонецЕсли;
	// Конец Подключение обработчика запроса настроек клиента лицензирования

КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// ПодключениеСервисовСопровождения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПодключениеСервисовСопровождения") Тогда
		МодульПодключениеСервисовСопровожденияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключениеСервисовСопровожденияКлиент");
		МодульПодключениеСервисовСопровожденияКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец ПодключениеСервисовСопровождения
	
	// ПолучениеОбновленийПрограмм
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
		МодульПолучениеОбновленийПрограммыКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммыКлиент
	
	// МониторПортала1СИТС
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторПортала1СИТС") Тогда
		МодульМониторПортала1СИТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МониторПортала1СИТСКлиент");
		МодульМониторПортала1СИТСКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец МониторПортала1СИТС
	
	// Новости
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец Новости

	// ОблачныйАрхив
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец ОблачныйАрхив

	// СПАРКРиски
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриНачалеРаботыСистемы();
	КонецЕсли;
	// Конец СПАРКРиски

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает Интернет-страницу в обозревателе.
//
// Параметры:
//	АдресСтраницы - Строка - URL-адрес открываемой страницы;
//	ЗаголовокОкна - Строка - заголовок открываемой страницы,
//		если для открытия страницы используется внутренняя форма конфигурации;
//	Логин - Строка - логин для авторизации на портале поддержи пользователей;
//	Пароль - Строка - пароль для авторизации на портале поддержки пользователей;
//
Процедура ОткрытьВебСтраницу(Знач АдресСтраницы, ЗаголовокОкна = "", Логин = Неопределено, Пароль = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗаголовокОкна", ЗаголовокОкна);
	ДополнительныеПараметры.Вставить("Логин"        , Логин);
	ДополнительныеПараметры.Вставить("Пароль"       , Пароль);
	
	ОткрытьВебСтраницуСДополнительнымиПараметрами(
		АдресСтраницы,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает Интернет-страницу в обозревателе.
//
Процедура ОткрытьВебСтраницуСДополнительнымиПараметрами(
	Знач АдресСтраницы,
	Знач ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗаголовокОкна"              , "");
	ПараметрыОткрытия.Вставить("Логин"                      , "");
	ПараметрыОткрытия.Вставить("Пароль"                     , "");
	ПараметрыОткрытия.Вставить("ЭтоПолноправныйПользователь", Неопределено);
	ПараметрыОткрытия.Вставить("НастройкиПрокси"            , Неопределено);
	ПараметрыОткрытия.Вставить("НастройкиСоединения"        , Неопределено);
	ПараметрыОткрытия.Вставить("РазделениеВключено"         , Ложь);
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ДополнительныеПараметры);
	КонецЕсли;
	
	Если ПараметрыОткрытия.ЭтоПолноправныйПользователь = Неопределено Тогда
		ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
		ПараметрыОткрытия.ЭтоПолноправныйПользователь =
			ПараметрыРаботыКлиента.ЭтоПолноправныйПользователь;
		ПараметрыОткрытия.РазделениеВключено = ПараметрыРаботыКлиента.РазделениеВключено;
	КонецЕсли;
	
	НеобходимаАвторизации = (СтрНайти(АдресСтраницы, "?needAccessToken=true") > 0
		Или СтрНайти(АдресСтраницы, "&needAccessToken=true") > 0);
	
	Если НеобходимаАвторизации Тогда
		// Удаление параметра из URL
		
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "?needAccessToken=true&", "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "?needAccessToken=true" , "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "&needAccessToken=true&", "");
		АдресСтраницы = СтрЗаменить(АдресСтраницы, "&needAccessToken=true" , "");
		
	КонецЕсли;
	
	URL = АдресСтраницы;
	Если НеобходимаАвторизации И ПараметрыОткрытия.ЭтоПолноправныйПользователь Тогда
		
		// Получение URL для открытия страницы.
		Состояние(, , НСтр("ru = 'Переход на Портал 1С:ИТС'"));
		РезультатПолученияURL = ИнтернетПоддержкаПользователейВызовСервера.СлужебнаяURLДляПереходаНаСтраницуИнтегрированногоСайта(АдресСтраницы);
		Состояние();
		
		Если Не ПустаяСтрока(РезультатПолученияURL.КодОшибки) И РезультатПолученияURL.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
			ПоказатьОповещениеПользователя(
				,
				,
				НСтр("ru = 'Ошибка входа на Портал 1С:ИТС.
					|Подробнее см. в журнале регистрации.'"),
				БиблиотекаКартинок.Ошибка32);
		КонецЕсли;
		
		URL = РезультатПолученияURL.URL;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияПодсистемБИПКлиент.ОткрытьИнтернетСтраницу(
		URL,
		ПараметрыОткрытия.ЗаголовокОкна,
		СтандартнаяОбработка);
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу(
		URL,
		ПараметрыОткрытия.ЗаголовокОкна,
		СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		// Открытие Интернет-страницы стандартным способом.
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(URL);
	КонецЕсли;
	
КонецПроцедуры

// Открывает страницу Портала 1С:ИТС для отправки сообщения в службу
// технической поддержки.
// В параметрах метода на страницу передаются данные заполнения.
//
// Параметры:
//	Тема - Строка - тема сообщения;
//	Тело - Строка - тело сообщения;
//	Получатель - Строка - условное имя получателя сообщения. Возможные значения:
//		- "webIts" - соответствует адресам "webits-info@1c.ru" и "webits-info@1c.ua",
//			необходимый адрес выбирается в соответствии с настройками доменной зоны
//			серверов Интернет-поддержки;
//		- "taxcom" - соответствует адресу "taxcom@1c.ru";
//		- "backup" - соответствует адресу "support.backup@1c.ru";
//	Вложения - Массив - массив значений типа Структура, файлы вложений.
//		Важно: допускаются только текстовые вложения (*.txt);
//		Поля структуры элемента вложения:
//			* Представление - Строка - представление вложения. Например:
//				"Вложение 1.txt";
//			Одно из полей:
//			* ИмяФайла - Строка - полное имя файла вложения;
//			* Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
//			* Текст - Строка - текст вложения;
//		К вложениям автоматически добавляется техническая информация о программе;
//	ДополнительныеПараметры - Структура - дополнительные параметры отправки сообщения. Поля:
//		* Логин - Строка - логин пользователя для входа на портал;
//		* Пароль - Строка - пароль пользователя для входа на портал;
//		* НастройкиСоединенияССерверами - Структура - см. функцию
//			ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами();
//		* ОповещениеОЗавершении - ОписаниеОповещения - метод, в который должен быть
//			передан результат отправки сообщения. В метод передается значение типа
//			Булево: Истина, данные сообщения переданы успешно,
//				Ложь - в противном случае.
//
Процедура ОтправитьСообщениеВТехПоддержку(
	Тема,
	Сообщение,
	Получатель = "webIts",
	Вложения = Неопределено,
	ДополнительныеПараметры = Неопределено) Экспорт

	Если Получатель <> "webIts" И Получатель <> "taxcom" И Получатель <> "backup" Тогда
		ВызватьИсключение НСтр("ru = 'Неизвестный получатель сообщения.'");
	КонецЕсли;

	Логин                         = Неопределено;
	Пароль                        = Неопределено;
	НастройкиСоединенияССерверами = Неопределено;
	ОповещениеОЗавершении         = Неопределено;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда

		Если ДополнительныеПараметры.Свойство("Логин") Тогда
			Логин = ДополнительныеПараметры.Логин;
		КонецЕсли;

		Если ДополнительныеПараметры.Свойство("Пароль") Тогда
			Пароль = ДополнительныеПараметры.Пароль;
		КонецЕсли;

		Если ДополнительныеПараметры.Свойство("НастройкиСоединенияССерверами") Тогда
			НастройкиСоединенияССерверами = ДополнительныеПараметры.НастройкиСоединенияССерверами;
		КонецЕсли;

		Если ДополнительныеПараметры.Свойство("ОповещениеОЗавершении") Тогда
			ОповещениеОЗавершении = ДополнительныеПараметры.ОповещениеОЗавершении;
		КонецЕсли;
		
	КонецЕсли;

	Если НастройкиСоединенияССерверами = Неопределено Тогда
		НастройкиСоединенияССерверами = НастройкиСоединенияССерверами();
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ВидПриложения", ВидПриложения());
	Если Логин <> Неопределено Тогда
		ДопПараметры.Вставить("Логин" , Логин);
		ДопПараметры.Вставить("Пароль", Пароль);
	КонецЕсли;

	Состояние(, , НСтр("ru = 'Подготовка сообщения в службу технической поддержки'"));

	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Тема"                 , Тема);
	ПараметрыСообщения.Вставить("Сообщение"            , Сообщение);
	ПараметрыСообщения.Вставить("Получатель"           , Получатель);
	ПараметрыСообщения.Вставить("Вложения"             , Вложения);
	ПараметрыСообщения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	ПараметрыСообщения.Вставить("ДопПараметры"         , ДопПараметры);
	
	ПодготовитьВложенияКОтправкеНаСервере(ПараметрыСообщения);
	
КонецПроцедуры

// Преобразует значение из фиксированного типа.
// Параметры:
//	ЗначениеФиксированногоТипа - Произвольный - значение фиксированного типа
//		из которого необходимо получить значение нефиксированного типа.
//
// Возвращаемое значение:
//	Произвольный - полученное значение аналогичного нефиксированного типа.
//
Функция ЗначениеИзФиксированногоТипа(ЗначениеФиксированногоТипа) Экспорт

	Результат = Неопределено;
	ТипЗначения = ТипЗнч(ЗначениеФиксированногоТипа);

	Если ТипЗначения = Тип("ФиксированнаяСтруктура") Тогда

		Результат = Новый Структура;
		Для каждого КлючЗначение Из ЗначениеФиксированногоТипа Цикл
			Результат.Вставить(КлючЗначение.Ключ, ЗначениеИзФиксированногоТипа(КлючЗначение.Значение));
		КонецЦикла;

	ИначеЕсли ТипЗначения = Тип("ФиксированноеСоответствие") Тогда

		Результат = Новый Соответствие;
		Для каждого КлючЗначение Из ЗначениеФиксированногоТипа Цикл
			Результат.Вставить(КлючЗначение.Ключ, ЗначениеИзФиксированногоТипа(КлючЗначение.Значение));
		КонецЦикла;

	ИначеЕсли ТипЗначения = Тип("ФиксированныйМассив") Тогда

		Результат = Новый Массив;
		Для каждого ЭлементМассива Из ЗначениеФиксированногоТипа Цикл
			Результат.Добавить(ЗначениеИзФиксированногоТипа(ЭлементМассива));
		КонецЦикла;

	Иначе

		Результат = ЗначениеФиксированногоТипа;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Получает значение параметра приложения.
//
Функция ЗначениеПараметраПриложения(ИмяПараметра, ЗначениеПоУмолчанию = Неопределено) Экспорт

	ПараметрыБиблиотеки = ПараметрыПриложения.Получить("ИнтернетПоддержкаПользователей");
	Если ПараметрыБиблиотеки = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

	ЗначениеПараметра = ПараметрыБиблиотеки.Получить(ИмяПараметра);
	Возврат ?(ЗначениеПараметра = Неопределено, ЗначениеПоУмолчанию, ЗначениеПараметра);

КонецФункции

// Устанавливает значение параметра приложения.
//
Процедура УстановитьЗначениеПараметраПриложения(ИмяПараметра, ЗначениеПараметра) Экспорт

	ПараметрыБиблиотеки = ПараметрыПриложения.Получить("ИнтернетПоддержкаПользователей");
	Если ПараметрыБиблиотеки = Неопределено Тогда
		ПараметрыБиблиотеки = Новый Соответствие;
		ПараметрыПриложения.Вставить(
			"ИнтернетПоддержкаПользователей",
			ПараметрыБиблиотеки);
	КонецЕсли;

	ПараметрыБиблиотеки.Вставить(ИмяПараметра, ЗначениеПараметра);

КонецПроцедуры

// Возвращает параметры клиентского приложения.
//
// Возвращаемое значение:
//	Структура - параметры клиентского приложения.
//		* ТипПлатформы - Строка - тип платформы;
//		* ВерсияОС - Строка - версия операционной системы;
//		* ЭтоКлиентЧерезВебСервер - Булево - признак того, что тонкий клиент
//			подключен через веб-сервер.
//
Функция ПараметрыКлиента() Экспорт
	
	Результат = Новый Структура;
	СистИнфо = Новый СистемнаяИнформация;
	Результат.Вставить("ТипПлатформы",
		ИнтернетПоддержкаПользователейКлиентСервер.ИмяТипПлатформыСтр(
			СистИнфо.ТипПлатформы));
	Результат.Вставить("ВерсияОС", СистИнфо.ВерсияОС);
	#Если ВебКлиент Тогда
	Результат.Вставить("ЭтоКлиентЧерезВебСервер", Ложь);
	#Иначе
	Результат.Вставить("ЭтоКлиентЧерезВебСервер",
		(НРег(Лев(СтрокаСоединенияИнформационнойБазы(), 3)) = "ws="));
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

// Открывает личный кабинет пользователя в обозревателе.
//
Процедура ОткрытьЛичныйКабинетПользователя() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"/software?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Личный кабинет пользователя'"));
	
КонецПроцедуры

// Открывает страницу Портала для восстановления пароля.
//
Процедура ОткрытьСтраницуВосстановленияПароля() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
			"/remind_request",
			НастройкиСоединенияССерверами()),
		НСтр("ru = 'Восстановление пароля'"));
	
КонецПроцедуры

// Открывает личный кабинет пользователя в обозревателе.
//
Процедура ОткрытьСтраницуОфициальнаяПоддержка() Экспорт
	
	ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки(
			"/support?needAccessToken=true",
			НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП),
		НСтр("ru = 'Официальная поддержка'"));
	
КонецПроцедуры

// Возвращает текст заголовка элемента формы из строки или форматированной строки.
//
Функция ТекстФорматированногоЗаголовка(Заголовок) Экспорт

	Если ТипЗнч(Заголовок) <> Тип("ФорматированнаяСтрока") Тогда
		Возврат Заголовок;
	КонецЕсли;

	ФДок = Новый ФорматированныйДокумент;
	ФДок.УстановитьФорматированнуюСтроку(Заголовок);
	Возврат ФДок.ПолучитьТекст();

КонецФункции

// Функция ищет первый элемент в списке значений по условиям.
//
// Параметры:
//  Список          - СписокЗначений - Список значений параметров;
//  ПараметрыПоиска - Структура - структура, описывающая условия поиска:
//    * ВариантПоиска - Строка - "ПоЗначению", "ПоПредставлению", "ПоПредставлениюБезУчетаРегистра";
//    * ЗначениеПоиска - Строка - Значение или представление, которое необходимо найти.
//
// Возвращаемое значение:
//   ЭлементСпискаЗначений - значение элемента списка значений, или Неопределено, если элемент не найден.
//
Функция НайтиЭлементСпискаЗначений(Список, ПараметрыПоиска) Экспорт

	ТипСписокЗначений = Тип("СписокЗначений");
	ТипСтруктура      = Тип("Структура");

	Результат = Неопределено;
	ВариантПоиска = "ПоЗначению";
	ЗначениеПоиска = Неопределено;

	Если ТипЗнч(Список) = ТипСписокЗначений Тогда
		Если ТипЗнч(ПараметрыПоиска) = ТипСтруктура Тогда
			Если ПараметрыПоиска.Свойство("ВариантПоиска") Тогда
				Если ВРег(ПараметрыПоиска.ВариантПоиска) = ВРег("ПоЗначению") Тогда
					// Значение по-умолчанию. Уже установлено.
				ИначеЕсли ВРег(ПараметрыПоиска.ВариантПоиска) = ВРег("ПоПредставлению") Тогда
					ВариантПоиска = "ПоПредставлению";
				ИначеЕсли ВРег(ПараметрыПоиска.ВариантПоиска) = ВРег("ПоПредставлениюБезУчетаРегистра") Тогда
					ВариантПоиска = "ПоПредставлениюБезУчетаРегистра";
				КонецЕсли;
			КонецЕсли;
			Если ПараметрыПоиска.Свойство("ЗначениеПоиска") Тогда
				ЗначениеПоиска = ПараметрыПоиска.ЗначениеПоиска;
			Иначе
				Возврат Результат;
			КонецЕсли;
		Иначе
			Возврат Результат;
		КонецЕсли;
		Если ВариантПоиска = "ПоЗначению" Тогда
			Результат = Список.НайтиПоЗначению(ЗначениеПоиска);
		ИначеЕсли ВариантПоиска = "ПоПредставлению" Тогда
			Для каждого ТекущийЭлементСписка Из Список Цикл
				Если ТекущийЭлементСписка.Представление = ЗначениеПоиска Тогда
					Результат = ТекущийЭлементСписка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ВариантПоиска = "ПоПредставлениюБезУчетаРегистра" Тогда
			Для каждого ТекущийЭлементСписка Из Список Цикл
				Если ВРег(ТекущийЭлементСписка.Представление) = ВРег(ЗначениеПоиска) Тогда
					Результат = ТекущийЭлементСписка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает массив, составленный из отмеченных значений списка значений.
//
// Параметры:
//  Список         - СписокЗначений, ДанныеФормыКоллекция - Список отмеченных значений;
//  ЗначениеОтбора - Булево - какое значение отбирать.
//
// Возвращаемое значение:
//   Массив - Массив отмеченных значений.
//
Функция ОтмеченныеЭлементыСпискаЗначений(Список, ЗначениеОтбора = Истина) Экспорт

	Результат = Новый Массив;

	Для Каждого ТекущийЭлементСписка Из Список Цикл
		Если ТекущийЭлементСписка.Пометка = ЗначениеОтбора Тогда
			Результат.Добавить(ТекущийЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОтправкаСообщенийВСлужбуТехническойПоддержки

Процедура ПодготовитьВложенияКОтправкеНаСервере(ПараметрыСообщения)
	
	ПомещаемыеФайлы = Новый Массив;
	Если ПараметрыСообщения.Вложения <> Неопределено Тогда
		Для каждого ТекВложение Из ПараметрыСообщения.Вложения Цикл
			Если ТекВложение.Свойство("ИмяФайла") Тогда
				ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(ТекВложение.ИмяФайла);
				ПомещаемыеФайлы.Добавить(ПередаваемыйФайл);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПомещаемыеФайлы.Количество() = 0 Тогда
		ПодготовитьВложенияКОтправкеЗавершение(Неопределено, ПараметрыСообщения);
	Иначе
		
		ПараметрыСообщения.Вставить("ПомещаемыеФайлы", ПомещаемыеФайлы);
		
		ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		ПараметрыЗагрузки.Интерактивно = Ложь;
		
		ФайловаяСистемаКлиент.ЗагрузитьФайлы(
			Новый ОписаниеОповещения(
				"ПодготовитьВложенияКОтправкеЗавершение",
				ЭтотОбъект,
				ПараметрыСообщения),
			ПараметрыЗагрузки,
			ПараметрыСообщения.ПомещаемыеФайлы);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьВложенияКОтправкеЗавершение(ФайлыВложений, ПараметрыСообщения) Экспорт

	Если ФайлыВложений <> Неопределено Тогда
		Для каждого ТекВложение Из ПараметрыСообщения.Вложения Цикл
			Если ТекВложение.Свойство("ИмяФайла") Тогда
				Для каждого ПФайл Из ФайлыВложений Цикл
					Если ПФайл.ПолноеИмя = ТекВложение.ИмяФайла Тогда
						ТекВложение.Удалить("ИмяФайла");
						ТекВложение.Вставить("Адрес", ПФайл.Хранение);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	РезультатОтправки = ИнтернетПоддержкаПользователейВызовСервера.ОтправитьДанныеСообщенияВТехПоддержку(
		ПараметрыСообщения.Тема,
		ПараметрыСообщения.Сообщение,
		ПараметрыСообщения.Получатель,
		ПараметрыСообщения.Вложения,
		ПараметрыСообщения.ДопПараметры);

	ПриОтправкеДанныхСообщенияВТехПоддержку(РезультатОтправки, ПараметрыСообщения);

КонецПроцедуры

Процедура ПриОтправкеДанныхСообщенияВТехПоддержку(РезультатОтправки, ПараметрыСообщения)

	Состояние();

	Результат = ПустаяСтрока(РезультатОтправки.КодОшибки);
	Если Результат Тогда

		Если Не ПустаяСтрока(РезультатОтправки.Предупреждение) Тогда
			ПоказатьОповещениеПользователя(
				,
				,
				РезультатОтправки.Предупреждение,
				БиблиотекаКартинок.Ошибка32);
		КонецЕсли;

		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗаголовокОкна", НСтр("ru = 'Отправка сообщения в службу технической поддержки'"));
		Если ТипЗнч(ПараметрыСообщения) = Тип("Структура") Тогда
			Если ПараметрыСообщения.Свойство("НастройкиПрокси") Тогда
				ПараметрыОткрытия.Вставить("НастройкиПрокси",
					ПараметрыСообщения.НастройкиПрокси);
			КонецЕсли;
			Если ПараметрыСообщения.Свойство("НастройкиСоединенияССерверами") Тогда
				ПараметрыОткрытия.Вставить("НастройкиСоединения",
					ПараметрыСообщения.НастройкиСоединенияССерверами);
			КонецЕсли;
			Если ПараметрыСообщения.Свойство("ЭтоПолноправныйПользователь") Тогда
				ПараметрыОткрытия.Вставить("ЭтоПолноправныйПользователь",
					ПараметрыСообщения.ЭтоПолноправныйПользователь);
			КонецЕсли;
		КонецЕсли;
		ОткрытьВебСтраницуСДополнительнымиПараметрами(
			РезультатОтправки.URLСтраницы,
			ПараметрыОткрытия);

		Если ПараметрыСообщения.ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ПараметрыСообщения.ОповещениеОЗавершении, Истина);
		КонецЕсли;

	Иначе

		ПоказатьПредупреждение(
			Новый ОписаниеОповещения(
				"ПриОшибкеОтправкиДанныхСообщенияВТехПоддержку",
				ЭтотОбъект,
				ПараметрыСообщения),
			РезультатОтправки.СообщениеОбОшибке);

	КонецЕсли;

КонецПроцедуры

Процедура ПриОшибкеОтправкиДанныхСообщенияВТехПоддержку(ПараметрыСообщения) Экспорт

	Если ПараметрыСообщения.ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ПараметрыСообщения.ОповещениеОЗавершении, Ложь);
	КонецЕсли;

КонецПроцедуры

Функция ВидПриложения()

	#Если ВебКлиент Тогда
	Возврат НСтр("ru = 'Веб-клиент'");
	#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
	Возврат НСтр("ru = 'Толстый клиент, обычное приложение'");
	#ИначеЕсли ТолстыйКлиентУправляемоеПриложение Тогда
	Возврат НСтр("ru = 'Толстый клиент, управляемое приложение'");
	#ИначеЕсли ТонкийКлиент Тогда
	Возврат НСтр("ru = 'Тонкий клиент'");
	#Иначе
	Возврат "";
	#КонецЕсли

КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

Процедура ПриНедоступностиПодключенияИПП(ОповещениеОЗавершении) Экспорт

	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
