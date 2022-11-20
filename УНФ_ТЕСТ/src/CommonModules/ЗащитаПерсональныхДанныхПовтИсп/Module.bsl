///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Функция формирует структуру, необходимую для установки индекса картинки 
// в таблице событий журнала регистрации.
//
Функция НомераКартинокСобытий152ФЗ() Экспорт
	
	НомераКартинок = Новый Соответствие;
	НомераКартинок.Вставить("_$Session$_.Authentication",		1);
	НомераКартинок.Вставить("_$Session$_.AuthenticationError",	2);
	НомераКартинок.Вставить("_$Session$_.Start",				3);
	НомераКартинок.Вставить("_$Session$_.Finish",				4);
	НомераКартинок.Вставить("_$Access$_.Access",				5);
	НомераКартинок.Вставить("_$Access$_.AccessDenied",			6);
	
	Возврат Новый ФиксированноеСоответствие(НомераКартинок);
	
КонецФункции

// Возвращает полные имена объектов метаданных содержащих персональные данные.
//
// Параметры:
//	Нет
//
// Возвращаемое значение
//	Массив - массив строк. Например: "РегистрСведений.ДокументыФизическихЛиц".
//
Функция ИменаИсточниковПерсональныхДанных() Экспорт
	
	ТаблицаСведений = ЗащитаПерсональныхДанныхПовтИсп.СведенияОПерсональныхДанных();
	ТаблицаСведений.Сортировать("Объект");
	
	ИменаИсточников = ТаблицаСведений.ВыгрузитьКолонку("Объект");
	ИменаИсточников = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИменаИсточников);
	
	Возврат Новый ФиксированныйМассив(ИменаИсточников);
	
КонецФункции

// Возвращает полные имена реквизитов объекта метаданных содержащего персональные данные по его полному имени.
//
// Параметры:
//	ИмяИсточника - Строка - полное имя источника метаданных. Например: "Справочник.ФизическиеЛица".
//
// Возвращаемое значение
//	Массив - массив строк. Например: "ФизическоеЛицо" или "ФизическиеЛица.ФизическоеЛицо".
//
Функция ИменаРеквизитовИсточникаСодержащихСубъект(ИмяИсточника) Экспорт
	
	ИменаРеквизитовСодержащихСубъект = Новый Массив;
	МетаданныеПоТипамСубъекта = ЗащитаПерсональныхДанныхПовтИсп.МетаданныеПоТипамСубъекта();
	
	МетаданныеИсточника = Метаданные.НайтиПоПолномуИмени(ИмяИсточника); // ОбъектМетаданныхСправочник
	ИсточникЭтоРегистр = ОбщегоНазначения.ЭтоРегистр(МетаданныеИсточника);
	ТипыСсылкиИсточника = ?(ИсточникЭтоРегистр, Новый Массив, МетаданныеИсточника.СтандартныеРеквизиты.Ссылка.Тип.Типы());
	ИсточникИмеетВладельца = ОбщегоНазначения.ЭтоСправочник(МетаданныеИсточника) И МетаданныеИсточника.Владельцы.Количество() > 0;
	
	ПоляСведений = ИменаПолейСведенийОПерсональныхДанныхОбъекта(ИмяИсточника);
	ПоляДоступа = ПоляСведений.ПоляДоступа;
	ПоляРегистрации = ПоляСведений.ПоляРегистрации;
	
	ИменаТЧСодержащихСведения = Новый Массив;
	
	Если Не ИсточникЭтоРегистр Тогда
		
		ИменаТабличныхЧастей = Новый Массив;
		ТабличныеЧасти = МетаданныеИсточника.ТабличныеЧасти;
		
		Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			ИменаТабличныхЧастей.Добавить(ТабличнаяЧасть.Имя);
		КонецЦикла;
		
		ИменаТЧСодержащихСведения = ИменаТЧОбъектаСодержащихСведенияОПерсональныхДанных(ИменаТабличныхЧастей, ПоляДоступа);
		
	КонецЕсли;
	
	Для Каждого ТипСубъектаИМетаданные Из МетаданныеПоТипамСубъекта Цикл
		
		ТипСубъекта = ТипСубъектаИМетаданные.Ключ;
		МетаданныеСубъекта = ТипСубъектаИМетаданные.Значение;
		
		ИменаРеквизитовИсточника = Новый Массив;
		ИменаРеквизитовТЧИсточника = Новый Соответствие;
		
		Если ИсточникЭтоРегистр Тогда
			
			ИменаИзмеренийТипа = ЗащитаПерсональныхДанных.ИменаИзмеренийРегистраПоТипу(МетаданныеИсточника, ТипСубъекта);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаРеквизитовИсточника, ИменаИзмеренийТипа);
			
		Иначе
			
			Если ТипыСсылкиИсточника.Найти(ТипСубъекта) <> Неопределено Тогда
				ИменаРеквизитовИсточника.Добавить("Ссылка");
			Иначе
				
				Если ИсточникИмеетВладельца Тогда
					
					Если МетаданныеИсточника.Владельцы.Содержит(МетаданныеСубъекта) Тогда
						ИменаРеквизитовИсточника.Добавить("Владелец");
					КонецЕсли;
					
				КонецЕсли;
				
				Если ИменаРеквизитовИсточника.Количество() = 0 Тогда
					
					ИменаРеквизитовТипа = ЗащитаПерсональныхДанных.ИменаРеквизитовПоТипу(МетаданныеИсточника, ТипСубъекта);
					ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаРеквизитовИсточника, ИменаРеквизитовТипа);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Для Каждого ИмяТабличнойЧасти Из ИменаТЧСодержащихСведения Цикл
				
				ИменаРеквизитовТЧТипа = ЗащитаПерсональныхДанных.ИменаРеквизитовТЧОбъектаПоТипу(МетаданныеИсточника, ИмяТабличнойЧасти, ТипСубъекта, Истина);
				Если ИменаРеквизитовТЧТипа.Количество() > 0 Тогда
					ИменаРеквизитовТЧИсточника.Вставить(ИмяТабличнойЧасти, ИменаРеквизитовТЧТипа);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого ИмяРеквизита Из ИменаРеквизитовИсточника Цикл
			
			Если ПоляРегистрации.Найти(ИмяРеквизита) <> Неопределено Тогда
				ИменаРеквизитовСодержащихСубъект.Добавить(ИмяРеквизита);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого ТЧИРеквизиты Из ИменаРеквизитовТЧИсточника Цикл
			
			ИменаРеквизитовТЧ = ТЧИРеквизиты.Значение;
			Для Каждого ИмяРеквизита Из ИменаРеквизитовТЧ Цикл
				
				Если ПоляРегистрации.Найти(ИмяРеквизита) <> Неопределено Тогда
					ИменаРеквизитовСодержащихСубъект.Добавить(ИмяРеквизита);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если ИменаРеквизитовСодержащихСубъект.Количество() > 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ИменаРеквизитовСодержащихСубъект);
	
КонецФункции

// Возвращает имена полей регистрации и полей доступа сведений о персональных данных объекта по его полному имени.
//
// Параметры:
//	ИмяОбъекта - Строка - полное имя объекта метаданных. Например: "Справочник.ФизическиеЛица".
//
// Возвращаемое значение
//	Структура:
///		ПоляРегистрации - Массив - массив строк. Например: "ФизическоеЛицо" или "ФизическиеЛица.ФизическоеЛицо".
///		ПоляДоступа - Массив - массив строк. Например: "ИНН" или "ФизическиеЛица.ИНН".
//
Функция ИменаПолейСведенийОПерсональныхДанныхОбъекта(ИмяОбъекта)
	
	ИменаПолейРегистрации = Новый Массив;
	ИменаПолейДоступа = Новый Массив;
	
	ТаблицаСведений = ЗащитаПерсональныхДанныхПовтИсп.СведенияОПерсональныхДанных();
	СтрокиСведений = ТаблицаСведений.НайтиСтроки(Новый Структура("Объект", ИмяОбъекта));
	
	Для Каждого СтрокаСведений Из СтрокиСведений Цикл
		
		ПоляДоступа = СтрРазделить(СтрокаСведений.ПоляДоступа, ",");
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаПолейДоступа, ПоляДоступа, Истина);
		
		ПоляРегистрации = СтрРазделить(СтрокаСведений.ПоляРегистрации, ",|");
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаПолейРегистрации, ПоляРегистрации, Истина);
		
	КонецЦикла;
	
	Возврат Новый Структура("ПоляДоступа,ПоляРегистрации", ИменаПолейДоступа, ИменаПолейРегистрации);
	
КонецФункции

Функция ИменаТЧОбъектаСодержащихСведенияОПерсональныхДанных(ИменаТЧОбъекта, ИменаРеквизитов)
	
	ИменаТЧСодержащихСведения = Новый Массив;
	
	Для Каждого ИмяТЧОбъекта Из ИменаТЧОбъекта Цикл
		
		ПодстрокаПоиска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.", ИмяТЧОбъекта);
		Для Каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			
			Если СтрНайти(ИмяРеквизита, ПодстрокаПоиска) <> 0 Тогда
				
				ИменаТЧСодержащихСведения.Добавить(ИмяТЧОбъекта);
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ИменаТЧСодержащихСведения;
	
КонецФункции

Функция СведенияОПерсональныхДанных() Экспорт
	
	Возврат ЗащитаПерсональныхДанных.СведенияОПерсональныхДанных();
	
КонецФункции

// Возвращаемое значение:
// 	ФиксированноеСоответствие:
//	  * Ключ - Тип
//	  * Значение -  ОбъектМетаданных
//
Функция МетаданныеПоТипамСубъекта() Экспорт
	
	ТипыСубъектов = ЗащитаПерсональныхДанныхПовтИсп.ТипыСубъектов();
	
	МетаданныеПоТипуСубъектов = Новый Соответствие;
	Для Каждого ТипСубъекта Из ТипыСубъектов Цикл
		МетаданныеПоТипуСубъектов.Вставить(ТипСубъекта, Метаданные.НайтиПоТипу(ТипСубъекта));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(МетаданныеПоТипуСубъектов);
	
КонецФункции

// Возвращаемое значение:
// 	ФиксированныйМассив - типы субъектов персональных данных.
//
Функция ТипыСубъектов() Экспорт
	
	ТипыСубъектов = Метаданные.ОпределяемыеТипы.СубъектПерсональныхДанных.Тип.Типы();
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ТипыСубъектов, Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	
	Возврат Новый ФиксированныйМассив(ТипыСубъектов);
	
КонецФункции

#КонецОбласти
