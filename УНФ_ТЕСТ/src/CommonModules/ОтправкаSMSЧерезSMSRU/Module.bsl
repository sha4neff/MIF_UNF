///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через SMS.RU.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерОтправителя.
//                                                  ИдентификаторСообщения.
//             ОписаниеОшибки        - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
//
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	// Подготовка строки получателей.
	СтрокаПолучателей = МассивПолучателейСтрокой(НомераПолучателей);
	
	// Проверка на заполнение обязательных параметров.
	Если ПустаяСтрока(СтрокаПолучателей) Или ПустаяСтрока(Текст) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверные параметры сообщения'");
		Возврат Результат;
	КонецЕсли;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("login", Логин);
	ПараметрыЗапроса.Вставить("password", Пароль);
	ПараметрыЗапроса.Вставить("text", Текст);
	ПараметрыЗапроса.Вставить("to", СтрокаПолучателей);
	ПараметрыЗапроса.Вставить("from", ИмяОтправителя);
	
	// отправка запроса
	ТекстОтвета = ВыполнитьЗапрос("sms/send", ПараметрыЗапроса);
	Если Не ЗначениеЗаполнено(ТекстОтвета) Тогда
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + НСтр("ru = 'Соединение не установлено'");
		Возврат Результат;
	КонецЕсли;
	
	ИдентификаторыСообщений = СтрРазделить(ТекстОтвета, Символы.ПС);
	
	ОтветСервера = ИдентификаторыСообщений[0];
	ИдентификаторыСообщений.Удалить(0);
	
	Если ОтветСервера = "100" Тогда
		НомераПолучателей = СтрРазделить(СтрокаПолучателей, ",", Ложь);
		Если ИдентификаторыСообщений.Количество() < НомераПолучателей.Количество() Тогда
			Результат.ОписаниеОшибки = НСтр("ru = 'Ответ сервера не распознан'");
			Возврат Результат;
		КонецЕсли;
		
		Для Индекс = 0 По НомераПолучателей.ВГраница() Цикл
			НомерПолучателя = НомераПолучателей[Индекс];
			ИдентификаторСообщения = ИдентификаторыСообщений[Индекс];
			Если Не ПустаяСтрока(НомерПолучателя) Тогда
				ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения",
					НомерПолучателя,ИдентификаторСообщения);
				Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Результат.ОписаниеОшибки = ОписаниеОшибкиОтправки(ОтветСервера);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке;
//  НастройкиОтправкиSMS   - см. ОтправкаSMSПовтИсп.НастройкиОтправкиSMS;
//
// Возвращаемое значение:
//   см. ОтправкаSMS.СтатусДоставки.
//
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	
	Логин = НастройкиОтправкиSMS.Логин;
	Пароль = НастройкиОтправкиSMS.Пароль;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("login", Логин);
	ПараметрыЗапроса.Вставить("password", Пароль);
	ПараметрыЗапроса.Вставить("id", ИдентификаторСообщения);
	
	// отправка запроса
	КодСостояния = ВыполнитьЗапрос("sms/status", ПараметрыЗапроса);
	Если Не ЗначениеЗаполнено(КодСостояния) Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(КодСостояния);
	Если Результат = "Ошибка" Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось получить статус доставки SMS (id: ""%3""):
			|%1 (код ошибки: %2)'"), ОписаниеОшибкиПолученияСтатуса(КодСостояния), КодСостояния, ИдентификаторСообщения);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СтатусДоставкиSMS(КодСостояния)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("-1", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("100", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("101", "Отправляется");
	СоответствиеСтатусов.Вставить("102", "Отправлено");
	СоответствиеСтатусов.Вставить("103", "Доставлено");
	СоответствиеСтатусов.Вставить("104", "НеДоставлено");
	СоответствиеСтатусов.Вставить("105", "НеДоставлено");
	СоответствиеСтатусов.Вставить("106", "НеДоставлено");
	СоответствиеСтатусов.Вставить("107", "НеДоставлено");
	СоответствиеСтатусов.Вставить("108", "НеДоставлено");
	
	Результат = СоответствиеСтатусов[НРег(КодСостояния)];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ОписанияОшибок()
	ОписанияОшибок = Новый Соответствие;
	ОписанияОшибок.Вставить("200", НСтр("ru = 'Авторизация не выполнена: неверный api_id.'"));
	ОписанияОшибок.Вставить("201", НСтр("ru = 'Недостаточно средств на лицевом счету.'"));
	ОписанияОшибок.Вставить("202", НСтр("ru = 'Неправильно указан получатель.'"));
	ОписанияОшибок.Вставить("203", НСтр("ru = 'Нет текста сообщения.'"));
	ОписанияОшибок.Вставить("204", НСтр("ru = 'Имя отправителя не согласовано с провайдером (SMS.RU).'"));
	ОписанияОшибок.Вставить("205", НСтр("ru = 'Сообщение слишком длинное (превышает 8 SMS).'"));
	ОписанияОшибок.Вставить("206", НСтр("ru = 'Достигнут дневной лимит на отправку сообщений.'"));
	ОписанияОшибок.Вставить("207", НСтр("ru = 'На этот номер (или один из номеров) нельзя отправлять сообщения, либо указано более 100 номеров в списке получателей'"));
	ОписанияОшибок.Вставить("208", НСтр("ru = 'Параметр time указан неправильно.'"));
	ОписанияОшибок.Вставить("209", НСтр("ru = 'Номер получателя (или один из номеров) в стоп-листе (см. в личном кабинете на сайте).'"));
	ОписанияОшибок.Вставить("210", НСтр("ru = 'Используется GET, где необходимо использовать POST.'"));
	ОписанияОшибок.Вставить("211", НСтр("ru = 'Метод не существует.'"));
	ОписанияОшибок.Вставить("212", НСтр("ru = 'Неверная кодировка текста сообщения (необходимо использовать UTF-8).'"));
	ОписанияОшибок.Вставить("220", НСтр("ru = 'Сервис временно недоступен.'"));
	ОписанияОшибок.Вставить("230", НСтр("ru = 'Сообщение не принято к отправке: достигнут дневной лимит сообщений на один номер (60 шт).'"));
	ОписанияОшибок.Вставить("300", НСтр("ru = 'Авторизация не выполнена: token устарел (истек срок действия, либо изменился IP отправителя.'"));
	ОписанияОшибок.Вставить("301", НСтр("ru = 'Авторизация не выполнена: логин или пароль указаны неверно.'"));
	ОписанияОшибок.Вставить("302", НСтр("ru = 'Авторизация не выполнена: пользователь авторизован, но аккаунт не подтвержден (пользователь не ввел код, присланный в регистрационной SMS.)'"));
	
	Возврат ОписанияОшибок;
КонецФункции

Функция ОписаниеОшибкиОтправки(КодОшибки)
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сообщение не отправлено (код ошибки: %1).'"), КодОшибки);
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ОписаниеОшибкиПолученияСтатуса(КодОшибки)
	ОписанияОшибок =ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отказ выполнения операции'");
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса)
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос("/" + ИмяМетода, ПараметрыЗапроса);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение("sms.ru", , , , ПолучениеФайловИзИнтернета.ПолучитьПрокси("https"),
			60, ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
			
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.'"), ИмяМетода, HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецЕсли;
		
		Возврат HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция МассивПолучателейСтрокой(Массив)
	Получатели = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Получатели, Массив, Истина);
	
	Результат = "";
	Для Каждого Получатель Из Получатели Цикл
		Номер = ФорматироватьНомер(Получатель);
		Если НЕ ПустаяСтрока(Номер) Тогда 
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ",";
			КонецЕсли;
			Результат = Результат + Номер;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив
//
Функция Разрешения() Экспорт
	
	Протокол = "HTTP";
	Адрес = "sms.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через ""SMS.RU"".'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "http://sms.ru";
	
КонецПроцедуры

#КонецОбласти

