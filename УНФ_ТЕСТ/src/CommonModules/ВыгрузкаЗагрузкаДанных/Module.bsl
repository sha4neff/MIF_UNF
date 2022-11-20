////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Данный модуль содержит интерфейсные процедуры функции
// вызова процессов выгрузки и загрузки данных.


#Область ПрограммныйИнтерфейс

// Выгружает данные в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива().
//
// Параметры:
//  ПараметрыВыгрузки - Структура - содержащая параметры выгрузки данных:
//		* ВыгружаемыеТипы - Массив - массив объектов метаданных, данные которых требуется выгрузить в архив
//      * ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      * ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
//
// Возвращаемое значение:		
//  Структура - с полями:
//  * ИмяФайла - Строка - имя файла архива
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам выгрузки.
//
Функция ВыгрузитьДанныеТекущейОбластиВАрхив(Знач ПараметрыВыгрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для выгрузки данных'");
	КонецЕсли;
	
	ВнешнийМонопольныйРежим = МонопольныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружаемыеТипы") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", Новый Массив());
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Ложь);
	КонецЕсли;
	
	Если Не ПараметрыВыгрузки.Свойство("ВыгружатьНастройкиПользователей") Тогда
		ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Ложь);
	КонецЕсли;
		
	Попытка
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Истина);
		КонецЕсли;
		
		РезультатВыгрузки = ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузитьДанныеТекущейОбластиВАрхив(ПараметрыВыгрузки);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		Возврат РезультатВыгрузки;
		
	Исключение
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецФункции

// Загружает данные из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка - полное имя файла архива с данными,
//  ПараметрыЗагрузки - Структура - содержащая параметры загрузки данных:
//		* ЗагружаемыеТипы - Массив Из ОбъектМетаданных - массив объектов метаданных, данные
//        	которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        	данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        	не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      * ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      * ЗагружатьНастройкиПользователей - Булево - игнорируется, если ЗагружатьПользователей = Ложь.
//      * СопоставлениеПользователей - ТаблицаЗначений - таблица с колонками:
//        ** Пользователь - СправочникСсылка.Пользователи - идентификатора пользователя из архива.
//        ** ИдентификаторПользователяСервиса - УникальныйИдентификатор - идентификатор пользователя сервиса.
//        ** СтароеИмяПользователяИБ - Строка - старое имя пользователя базы.
//        ** НовоеИмяПользователяИБ - Строка - новое имя пользователя базы.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
// Возвращаемое значение:		
//  Структура - с полями:
//  * Предупреждения - Массив Из Строка - предупреждения пользователю по результатам загрузки.
//
Функция ЗагрузитьДанныеТекущейОбластиИзАрхива(Знач ИмяАрхива, Знач ПараметрыЗагрузки) Экспорт
	
	Если Не ПроверитьНаличиеПрав() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для загрузки данных'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийМонопольныйРежим = МонопольныйРежим();
	
	Попытка
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Истина);
		КонецЕсли;
		
		РезультатЗагрузки = ВыгрузкаЗагрузкаДанныхСлужебный.ЗагрузитьДанныеТекущейОбластиИзАрхива(ИмяАрхива, ПараметрыЗагрузки);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		Возврат РезультатЗагрузки;
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Загрузка данных из архива'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ТекстИсключения);
		
		Если Не ВнешнийМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецФункции

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка - путь к файлу выгрузки.
//
// Возвращаемое значение: 
//	Булево - Истина если данные из архива могут быть загружены в текущую конфигурацию.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт
	
	Каталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(Каталог);
	Каталог = Каталог + ПолучитьРазделительПути();
	
	Архиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		
		ЭлементОписанияВыгрузки = Архиватор.Элементы.Найти("DumpInfo.xml");
		
		Если ЭлементОписанияВыгрузки = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'В файле выгрузки отсутствует файл DumpInfo.xml'");
		КонецЕсли;
		
		Архиватор.Извлечь(ЭлементОписанияВыгрузки, Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		
		ФайлОписанияВыгрузки = Каталог + "DumpInfo.xml";
		
		ИнформацияОВыгрузке = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектXDTOИзФайла(
			ФайлОписанияВыгрузки, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo"));
		
		Результат = ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИнформацияОВыгрузке)
			И ВыгрузкаЗагрузкаДанныхСлужебный.ВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(ИнформацияОВыгрузке);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		Возврат Результат;
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(Каталог);
		Архиватор.Закрыть();
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецФункции

// Записывает объект в файл.
//
// Параметры:
//	Объект - Произвольный - записываемый объект.
//	ИмяФайла - Строка - путь к файлу.
//	Сериализатор - СериализаторXDTO - сериализатор.
//
Процедура ЗаписатьОбъектВФайл(Знач Объект, Знач ИмяФайла, Сериализатор = Неопределено) Экспорт
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	
	ВыгрузкаЗагрузкаДанныхСлужебный.ЗаписатьОбъектВПоток(Объект, ПотокЗаписи, Сериализатор);
	
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

// Возвращает объект из файла.
//
// Параметры:
//	ИмяФайла - Строка - путь к файлу.
//
// Возвращаемое значение:
//	Произвольный - объект содержащий прочитанные данные
//
Функция ПрочитатьОбъектИзФайла(Знач ИмяФайла) Экспорт
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Объект = ВыгрузкаЗагрузкаДанныхСлужебный.ПрочитатьОбъектИзПотока(ПотокЧтения);
	
	ПотокЧтения.Закрыть();
	
	Возврат Объект;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеТекущейОбластиВАрхив
// Выгружает данные в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива().
//
// Параметры:
//  ПараметрыВыгрузки - Структура - содержащая параметры выгрузки данных:
//		* ВыгружаемыеТипы - Массив - массив объектов метаданных, данные которых требуется выгрузить в архив
//      * ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//      * ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков выгрузки данных.
//
// Возвращаемое значение:
//	Строка - путь к файлу выгрузки.
//
Функция ВыгрузитьДанныеВАрхив(Знач ПараметрыВыгрузки) Экспорт
	
	Возврат ВыгрузитьДанныеТекущейОбластиВАрхив(ПараметрыВыгрузки).ИмяФайла;
	
КонецФункции

// Устарела. Следует использовать ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеТекущейОбластиИзАрхива
// Загружает данные из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка - полное имя файла архива с данными,
//  ПараметрыЗагрузки - Структура - содержащая параметры загрузки данных:
//		* ЗагружаемыеТипы - Массив Из ОбъектМетаданных - массив объектов метаданных, данные
//        	которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        	данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        	не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      * ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      * ЗагружатьНастройкиПользователей - Булево - игнорируется, если ЗагружатьПользователей = Ложь.
//      * СопоставлениеПользователей - ТаблицаЗначений - таблица с колонками:
//        ** Пользователь - СправочникСсылка.Пользователи - идентификатора пользователя из архива.
//        ** ИдентификаторПользователяСервиса - УникальныйИдентификатор - идентификатор пользователя сервиса.
//        ** СтароеИмяПользователяИБ - Строка - старое имя пользователя базы.
//        ** НовоеИмяПользователяИБ - Строка - новое имя пользователя базы.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
Процедура ЗагрузитьДанныеИзАрхива(Знач ИмяАрхива, Знач ПараметрыЗагрузки) Экспорт
	
	ЗагрузитьДанныеТекущейОбластиИзАрхива(ИмяАрхива, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие права "АдминистрированиеДанных"
//
// Возвращаемое значение:
//	Булево - Истина, если имеется, Ложь - иначе.
//
Функция ПроверитьНаличиеПрав()
	
	Возврат ПравоДоступа("АдминистрированиеДанных", Метаданные);
	
КонецФункции

#КонецОбласти