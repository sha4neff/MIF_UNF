///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПолеОбработкаДляЗагрузкиДанных;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ЭкспортныеСвойства

// Функция-свойство: результат выполнения обмена данными.
//  Возвращаемое значение:
//      ПеречислениеСсылка.РезультатыВыполненияОбмена - результат выполнения обмена данными.
//
Функция РезультатВыполненияОбмена() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат Перечисления.РезультатыВыполненияОбмена.Отменено;
	КонецЕсли;
	
	РезультатВыполненияОбмена = КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена;
	Если РезультатВыполненияОбмена = Неопределено Тогда
		Возврат Перечисления.РезультатыВыполненияОбмена.Выполнено;
	КонецЕсли;
	
	Возврат РезультатВыполненияОбмена;
	
КонецФункции

// Функция-свойство: результат выполнения обмена данными.
//
//  Возвращаемое значение: 
//      Строка - результат выполнения обмена данными.
//
Функция РезультатВыполненияОбменаСтрокой() Экспорт
	
	Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(РезультатВыполненияОбмена());
	
КонецФункции


// Функция-свойство: количество объектов, которые были загружены.
//
//  Возвращаемое значение:
//      Число - количество объектов, которые были загружены.
//
Функция СчетчикЗагруженныхОбъектов() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат КомпонентыОбмена.СчетчикЗагруженныхОбъектов;
	
КонецФункции

// Функция-свойство: количество объектов, которые были выгружены.
//
//  Возвращаемое значение:
//      Число - количество объектов, которые были выгружены.
//
Функция СчетчикВыгруженныхОбъектов() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат КомпонентыОбмена.СчетчикВыгруженныхОбъектов;
	
КонецФункции

// Функция-свойство: строка, которая содержит сообщение об ошибке при обмене данными.
//
//  Возвращаемое значение:
//      Строка - сообщение об ошибке при обмене данными.
//
Функция СтрокаСообщенияОбОшибке() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	
КонецФункции

// Функция-свойство: флаг ошибки выполнения обмена данными.
//
//  Возвращаемое значение:
//     Булево - флаг ошибки выполнения обмена данными.
//
Функция ФлагОшибки() Экспорт
	
	Возврат КомпонентыОбмена.ФлагОшибки;
	
КонецФункции

// Функция-свойство: номер сообщения обмена данными.
//
//  Возвращаемое значение:
//      Число - номер сообщения обмена данными.
//
Функция НомерСообщения() Экспорт
	
	Возврат КомпонентыОбмена.НомерВходящегоСообщения;
	
КонецФункции

// Функция-свойство: таблица значений со статистической и дополнительной информацией о входящем сообщении обмена.
//
//  Возвращаемое значение:
//      ТаблицаЗначений - содержит статистическую и дополнительную информацию о входящем сообщении обмена.
//
Функция ТаблицаДанныхЗаголовкаПакета() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат ОбменДаннымиXDTOСервер.НоваяТаблицаДанныхЗаголовкаПакета();
	Иначе
		Возврат КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета;
	КонецЕсли;
	
КонецФункции

// Функция-свойство: соответствие с таблицами данных входящего сообщения обмена.
//
//  Возвращаемое значение:
//      Соответствие - содержит таблицы данных входящего сообщения обмена.
//
Функция ТаблицыДанныхСообщенияОбмена() Экспорт
	
	Если КомпонентыОбмена = Неопределено Тогда
		Возврат Новый Соответствие;
	Иначе
		Возврат КомпонентыОбмена.ТаблицыДанныхСообщенияОбмена;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ВыгрузкаДанных

// Выполняет выгрузку данных
// -- Все объекты выгружаются в один файл.
//
// Параметры:
//      ОбработкаДляЗагрузкиДанных - ОбработкаОбъект.КонвертацияОбъектовXDTO - обработка для загрузки в COM-соединении.
//
Процедура ВыполнитьВыгрузкуДанных(ОбработкаДляЗагрузкиДанных = Неопределено) Экспорт
	
	ПолеОбработкаДляЗагрузкиДанных = ОбработкаДляЗагрузкиДанных;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка");
	
	#Область НастройкаКомпонентовОбменаНаРаботуСУзлом
	КомпонентыОбмена.УзелКорреспондента = УзелДляОбмена;
	
	КомпонентыОбмена.ТолькоНастройкиXDTO = Не ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(
		КомпонентыОбмена.УзелКорреспондента);
	Если Не КомпонентыОбмена.ТолькоНастройкиXDTO Тогда
		КомпонентыОбмена.ВерсияФорматаОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			КомпонентыОбмена.УзелКорреспондента, "ВерсияФорматаОбмена");
	КонецЕсли;
		
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(КомпонентыОбмена.УзелКорреспондента);
	КомпонентыОбмена.XMLСхема = ОбменДаннымиXDTOСервер.ФорматОбмена(ИмяПланаОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	
	ОбменДаннымиXDTOСервер.ВключитьПространствоИмен(
		КомпонентыОбмена,
		ОбменДаннымиXDTOСервер.СхемаРасширенияФормата(КомпонентыОбмена.УзелКорреспондента),
		"ext");
	
	Если Не КомпонентыОбмена.ТолькоНастройкиXDTO Тогда
		
		КомпонентыОбмена.МенеджерОбмена = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(
			КомпонентыОбмена.ВерсияФорматаОбмена, КомпонентыОбмена.УзелКорреспондента);
		
		КомпонентыОбмена.ТаблицаПравилаРегистрацииОбъектов = ОбменДаннымиXDTOСервер.ПравилаРегистрацииОбъектов(
			КомпонентыОбмена.УзелКорреспондента);
		КомпонентыОбмена.СвойстваУзлаПланаОбмена = ОбменДаннымиXDTOСервер.СвойстваУзлаПланаОбмена(
			КомпонентыОбмена.УзелКорреспондента);
			
		ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
		ОбменДаннымиXDTOСервер.ЗаполнитьСтруктуруНастроекXDTO(КомпонентыОбмена);
		ОбменДаннымиXDTOСервер.ЗаполнитьПоддерживаемыеОбъектыXDTO(КомпонентыОбмена);
		
		КомпонентыОбмена.ПропускатьОбъектыСОшибкамиПроверкиПоСхеме = ОбменДаннымиXDTOСервер.ПропускатьОбъектыСОшибкамиПроверкиПоСхеме(
			КомпонентыОбмена.УзелКорреспондента);
		
	Иначе
		
		ОбменДаннымиXDTOСервер.ЗаполнитьСтруктуруНастроекXDTO(КомпонентыОбмена);
		
	КонецЕсли;
	#КонецОбласти
	
	Если Не КомпонентыОбмена.ТолькоНастройкиXDTO Тогда
		КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
		
		ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	КонецЕсли;
	
	// Открываем файл обмена.
	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Отказ = Ложь;
	Попытка
		ПослеОткрытияФайлаВыгрузки(Отказ);
		// ВЫГРУЗКА ДАННЫХ
		Если Не Отказ Тогда
			ОбменДаннымиXDTOСервер.ПроизвестиВыгрузкуДанных(КомпонентыОбмена);
		КонецЕсли;
	Исключение
		Инфо = ИнформацияОбОшибке();
		КодОшибки = Новый Структура("КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки",
			КраткоеПредставлениеОшибки(Инфо), ПодробноеПредставлениеОшибки(Инфо));
		
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, КодОшибки);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		Отказ = Истина;
	КонецПопытки;
	
	Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
		РазблокироватьДанныеДляРедактирования(КомпонентыОбмена.УзелКорреспондента);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыгрузкиXML = КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
	Если ЭтоОбменЧерезВнешнееСоединение() Тогда
		Если ОбработкаДляЗагрузкиДанных().РежимЗагрузкиДанных = "ЗагрузкаСообщенияДляСопоставленияДанных" Тогда
			Если Не КомпонентыОбмена.ФлагОшибки Тогда
				ОбработкаДляЗагрузкиДанных().ПоместитьСообщениеДляСопоставленияДанных(ДанныеВыгрузкиXML);
			Иначе
				ОбработкаДляЗагрузкиДанных().ПоместитьСообщениеДляСопоставленияДанных(Неопределено);
			КонецЕсли;
		Иначе
			Если Не КомпонентыОбмена.ФлагОшибки Тогда
				Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ЗагрузкаДанныхВыполняетсяЧерезВнешнееСоединение", ОбработкаДляЗагрузкиДанных().Метаданные())
					И ОбработкаДляЗагрузкиДанных().ЗагрузкаДанныхВыполняетсяЧерезВнешнееСоединение Тогда
					ОбработкаДляЗагрузкиДанных().ЗагрузитьДанныеСообщенияОбмена(ДанныеВыгрузкиXML);
				Иначе
					ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
				
					ТекстовыйДокумент = Новый ТекстовыйДокумент;
					ТекстовыйДокумент.ДобавитьСтроку(ДанныеВыгрузкиXML);
					ТекстовыйДокумент.Записать(ИмяВременногоФайла,,Символы.ПС);
					
					ОбработкаДляЗагрузкиДанных().ИмяФайлаОбмена = ИмяВременногоФайла;
					ОбработкаДляЗагрузкиДанных().ВыполнитьЗагрузкуДанных();
				
					УдалитьФайлы(ИмяВременногоФайла);
				КонецЕсли;
			Иначе
				ОбработкаДляЗагрузкиДанных().ИмяФайлаОбмена = "";
				ОбработкаДляЗагрузкиДанных().ВыполнитьЗагрузкуДанных();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанных

// Выполняет загрузку данных из файла сообщения обмена.
// Данные загружаются в информационную базу.
//
// Параметры:
//  ПараметрыЗагрузки - Структура
//                    - Неопределено - служебный параметр. Не предназначен для использования.
//
Процедура ВыполнитьЗагрузкуДанных(ПараметрыЗагрузки = Неопределено) Экспорт
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = Новый Структура;
	КонецЕсли;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
	ОбменДаннымиСВнешнейСистемой = Неопределено;
	Если ПараметрыЗагрузки.Свойство("ОбменДаннымиСВнешнейСистемой", ОбменДаннымиСВнешнейСистемой) Тогда
		КомпонентыОбмена.ОбменДаннымиСВнешнейСистемой = ОбменДаннымиСВнешнейСистемой;
	КонецЕсли;
	
	РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу";
	
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	Если ПустаяСтрока(ИмяФайлаОбмена) Тогда
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Возврат;
	КонецЕсли;
	
	Если ПродолжитьПриОшибке Тогда
		ИспользоватьТранзакции = Ложь;
		КомпонентыОбмена.ИспользоватьТранзакции = Ложь;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Отказ = Ложь;
	ПослеОткрытияФайлаЗагрузки(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатАнализаДанныхКЗагрузке = ОбменДаннымиСервер.РезультатАнализаДанныхКЗагрузке(ИмяФайлаОбмена, Истина);
	РезультатАнализаДанныхКЗагрузке.Вставить("КорреспондентПоддерживаетИдентификаторОбменаДанными",
											КомпонентыОбмена.КорреспондентПоддерживаетИдентификаторОбменаДанными);
	КомпонентыОбмена.Вставить("РазмерФайлаСообщенияОбмена", РезультатАнализаДанныхКЗагрузке.РазмерФайлаСообщенияОбмена);
	КомпонентыОбмена.Вставить("КоличествоОбъектовКЗагрузке", РезультатАнализаДанныхКЗагрузке.КоличествоОбъектовКЗагрузке);
	
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина);
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
	Исключение
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
		Информация = ИнформацияОбОшибке();
		СтрокаСообщения = НСтр("ru = 'Ошибка при загрузке данных: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаСообщения, ПодробноеПредставлениеОшибки(Информация));
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения, , , , , Истина);
		КомпонентыОбмена.ФлагОшибки = Истина;
	КонецПопытки;
	
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина);
	Попытка
		ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
	Исключение
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
		Информация = ИнформацияОбОшибке();
		СтрокаСообщения = НСтр("ru = 'Ошибка при удалении временных объектов, созданных по ссылкам: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаСообщения, ПодробноеПредставлениеОшибки(Информация));
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения, , , , , Истина);
		КомпонентыОбмена.ФлагОшибки = Истина;
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	Если Не КомпонентыОбмена.ФлагОшибки Тогда
		// Проверка данных From / NewFrom.
		ПроверитьКодыУзлов(РезультатАнализаДанныхКЗагрузке, КомпонентыОбмена.УзелКорреспондента);
		
		// Запишем информацию о номере входящего сообщения.
		НачатьТранзакцию();
		Попытка
			БлокировкаДанных = Новый БлокировкаДанных;
			
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("ПланОбмена." + ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(КомпонентыОбмена.УзелКорреспондента));
			ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", КомпонентыОбмена.УзелКорреспондента);
			
			БлокировкаДанных.Заблокировать();
	
			ОбъектУзла = КомпонентыОбмена.УзелКорреспондента.ПолучитьОбъект();
			ОбъектУзла.НомерПринятого = КомпонентыОбмена.НомерВходящегоСообщения;
			ОбъектУзла.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
			ОбъектУзла.Записать();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
КонецПроцедуры

// Выполняет загрузку данных из файла сообщения обмена в Информационную Базу только заданных типов объектов.
//
// Параметры:
//  ТаблицыДляЗагрузки - Массив из Строка - массив типов, которые необходимо загрузить из сообщения обмена.
//                       Например, для загрузки из сообщения обмена только элементов справочника "Демо: Контрагенты":
//                         ТаблицыДляЗагрузки = Новый Массив;
//                         ТаблицыДляЗагрузки.Добавить("СправочникСсылка._ДемоКонтрагенты");
//                       Список всех типов, которые содержаться в текущем сообщении обмена,
//                       можно получить вызовом процедуры ВыполнитьАнализСообщенияОбмена().
// 
Процедура ВыполнитьЗагрузкуДанныхВИнформационнуюБазу(ТаблицыДляЗагрузки) Экспорт
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
	РежимЗагрузкиДанных = "ЗагрузкаВИнформационнуюБазу";
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Отказ = Ложь;
	ПослеОткрытияФайлаЗагрузки(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Запись в журнале регистрации.
	СтрокаСообщения = НСтр("ru = 'Начало процесса обмена данными для узла: %1'", ОбщегоНазначения.КодОсновногоЯзыка());
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, Строка(УзелОбменаЗагрузкаДанных));
	ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Информация);
	
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина);
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена, ТаблицыДляЗагрузки);
	Исключение
		Информация = ИнформацияОбОшибке();
		СтрокаСообщения = НСтр("ru = 'Ошибка при загрузке данных: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаСообщения, ПодробноеПредставлениеОшибки(Информация));
		ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	
	Попытка
		ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
	Исключение
		Информация = ИнформацияОбОшибке();
		СтрокаСообщения = НСтр("ru = 'Ошибка при удалении временных объектов, созданных по ссылкам: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаСообщения, ПодробноеПредставлениеОшибки(Информация));
		ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
	
	// Запись в журнале регистрации.
	СтрокаСообщения = НСтр("ru = 'Выполняемое действие: %1;
		|Статус завершения: %2;
		|Обработано объектов: %3.'",
		ОбщегоНазначения.КодОсновногоЯзыка());
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
					КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена,
					Перечисления.ДействияПриОбмене.ЗагрузкаДанных,
					Формат(КомпонентыОбмена.СчетчикЗагруженныхОбъектов, "ЧГ=0"));
	
	ОбменДаннымиXDTOСервер.ЗаписьЖурналаРегистрацииОбменДанными(СтрокаСообщения, КомпонентыОбмена, УровеньЖурналаРегистрации.Информация);
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
КонецПроцедуры

// Выполняет последовательное чтение файла сообщения обмена при этом:
//  - удаляется регистрация изменений по номеру входящей квитанции
//  - загружаются правила обмена
//  - загружается информация о типах данных
//  - зачитывается информация сопоставления данных и записывается и ИБ
//  - собирается информация о типах объектов и их количестве.
//
// Параметры:
//      ПараметрыАнализа - Структура - не используется, оставлен для целей совместимости.
// 
Процедура ВыполнитьАнализСообщенияОбмена(ПараметрыАнализа = Неопределено) Экспорт
	
	РежимЗагрузкиДанных = "ЗагрузкаВТаблицуЗначений";
	ИспользоватьТранзакции = Ложь;
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	КомпонентыОбмена.РежимЗагрузкиДанныхВИнформационнуюБазу = Ложь;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	Если ПустаяСтрока(ИмяФайлаОбмена) Тогда
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Отказ = Ложь;
	ПослеОткрытияФайлаЗагрузки(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		// Зачитываем данные из сообщения обмена.
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанныхВРежимеАнализа(КомпонентыОбмена, ПараметрыАнализа);
		
		ТаблицаДанныхЗаголовкаПакета = КомпонентыОбмена.ТаблицаДанныхЗаголовкаПакета; // ТаблицаЗначений
		
		// Формируем временную таблицу данных.
		ТаблицаДанныхЗаголовкаПакетаВременная = ТаблицаДанныхЗаголовкаПакета.Скопировать(, "ТипИсточникаСтрокой, ТипПриемникаСтрокой, ПоляПоиска, ПоляТаблицы");
		ТаблицаДанныхЗаголовкаПакетаВременная.Свернуть("ТипИсточникаСтрокой, ТипПриемникаСтрокой, ПоляПоиска, ПоляТаблицы");
		
		// Сворачиваем таблицу данных заголовка пакета.
		ТаблицаДанныхЗаголовкаПакета.Свернуть(
			"ТипОбъектаСтрокой, ТипИсточникаСтрокой, ТипПриемникаСтрокой, СинхронизироватьПоИдентификатору, ЭтоКлассификатор, ЭтоУдалениеОбъекта, ИспользоватьПредварительныйПросмотр",
			"КоличествоОбъектовВИсточнике");
		
		ТаблицаДанныхЗаголовкаПакета.Колонки.Добавить("ПоляПоиска",  Новый ОписаниеТипов("Строка"));
		ТаблицаДанныхЗаголовкаПакета.Колонки.Добавить("ПоляТаблицы", Новый ОписаниеТипов("Строка"));
		
		Для Каждого СтрокаТаблицы Из ТаблицаДанныхЗаголовкаПакета Цикл
			
			Отбор = Новый Структура;
			Отбор.Вставить("ТипИсточникаСтрокой", СтрокаТаблицы.ТипИсточникаСтрокой);
			Отбор.Вставить("ТипПриемникаСтрокой", СтрокаТаблицы.ТипПриемникаСтрокой);
			
			СтрокиВременнойТаблицы = ТаблицаДанныхЗаголовкаПакетаВременная.НайтиСтроки(Отбор);
			
			СтрокаТаблицы.ПоляПоиска  = СтрокиВременнойТаблицы[0].ПоляПоиска;
			СтрокаТаблицы.ПоляТаблицы = СтрокиВременнойТаблицы[0].ПоляТаблицы;
			
		КонецЦикла;
		
	Исключение
		СтрокаСообщения = НСтр("ru = 'Ошибка при анализе данных: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СтрокаСообщения,,,,,Истина);
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
	
КонецПроцедуры

// Выполняет загрузку данных из файла сообщения обмена в Таблицу значений только заданных типов объектов.
//
// Параметры:
//  ТаблицыДляЗагрузки - Массив из Строка - массив типов, которые необходимо загрузить из сообщения обмена.
//                       Например, для загрузки из сообщения обмена только элементов справочника "Демо: Контрагенты":
//                         ТаблицыДляЗагрузки = Новый Массив;
//                         ТаблицыДляЗагрузки.Добавить("СправочникСсылка._ДемоКонтрагенты");
//                       Список всех типов, которые содержаться в текущем сообщении обмена,
//                       можно получить вызовом процедуры ВыполнитьАнализСообщенияОбмена().
// 
Процедура ВыполнитьЗагрузкуДанныхВТаблицуЗначений(ТаблицыДляЗагрузки) Экспорт
	
	РежимЗагрузкиДанных = "ЗагрузкаВТаблицуЗначений";
	ИспользоватьТранзакции = Ложь;
	
	ИнициализироватьТаблицыПравил = (КомпонентыОбмена = Неопределено);
	
	Если КомпонентыОбмена = Неопределено Тогда
		КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
		КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
		КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайлаОбмена);
	
	Отказ = Ложь;
	ПослеОткрытияФайлаЗагрузки(Отказ, ИнициализироватьТаблицыПравил);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	КомпонентыОбмена.РежимЗагрузкиДанныхВИнформационнуюБазу = Ложь;
	
	// Инициализируем таблицы данных сообщения обмена.
	Для Каждого КлючТаблицыДанных Из ТаблицыДляЗагрузки Цикл
		
		МассивПодстрок = СтрРазделить(КлючТаблицыДанных, "#");
		
		ТипОбъекта = МассивПодстрок[1];
		
		КомпонентыОбмена.ТаблицыДанныхСообщенияОбмена.Вставить(КлючТаблицыДанных, ИнициализацияТаблицыДанныхСообщенияОбмена(Тип(ТипОбъекта)));
		
	КонецЦикла;
	
	ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена, ТаблицыДляЗагрузки);
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет помещение файла обмена в сервис хранения файлов для последующего сопоставления.
// Загрузка данных не выполняется.
//
Процедура ПоместитьСообщениеДляСопоставленияДанных(ДанныеВыгрузкиXML) Экспорт
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Получение");
	
	КомпонентыОбмена.УзелКорреспондента = УзелОбменаЗагрузкаДанных;
	
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = КлючСообщенияЖурналаРегистрации;
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = ВыводВПротоколИнформационныхСообщений;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьВедениеПротоколаОбмена(КомпонентыОбмена, ИмяФайлаПротоколаОбмена);
	
	Если Не ЗначениеЗаполнено(ДанныеВыгрузкиXML) Тогда
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, 15);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		
		ИдентификаторФайла = "";
	Иначе
		КаталогВыгрузки = ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов();
		ИмяВременногоФайла = ОбменДаннымиСервер.УникальноеИмяФайлаСообщенияОбмена();
		
		ПолноеИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
			КаталогВыгрузки, ИмяВременногоФайла);
			
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.ДобавитьСтроку(ДанныеВыгрузкиXML);
		ТекстовыйДокумент.Записать(ПолноеИмяВременногоФайла, , Символы.ПС);
		
		ИдентификаторФайла = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ПолноеИмяВременногоФайла);
	КонецЕсли;
	
	ОбменДаннымиСлужебный.ПоместитьСообщениеДляСопоставленияДанных(УзелОбменаЗагрузкаДанных, ИдентификаторФайла);
	
КонецПроцедуры

Процедура ЗагрузитьДанныеСообщенияОбмена(ДанныеВыгрузкиXML) Экспорт
	
	ИмяФайлаОбмена = ПолучитьИмяВременногоФайла("xml");
				
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(ДанныеВыгрузкиXML);
	ТекстовыйДокумент.Записать(ИмяФайлаОбмена, , Символы.ПС);
	
	ВыполнитьЗагрузкуДанных();
	
	УдалитьФайлы(ИмяФайлаОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ИнициализацияТаблицыДанныхСообщенияОбмена(ТипОбъекта)
	
	ТаблицаДанныхСообщенияОбмена = Новый ТаблицаЗначений;
	
	Колонки = ТаблицаДанныхСообщенияОбмена.Колонки;
	
	// обязательные поля
	Колонки.Добавить("УникальныйИдентификатор", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(36)));
	Колонки.Добавить("ТипСтрокой",              Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(255)));
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	// Получаем описание всех полей объекта метаданного из конфигурации.
	ТаблицаОписанияСвойствОбъекта = ОбщегоНазначения.ОписаниеСвойствОбъекта(ОбъектМетаданных, "Имя, Тип");
	
	Для Каждого ОписаниеСвойства Из ТаблицаОписанияСвойствОбъекта Цикл
		
		Колонки.Добавить(ОписаниеСвойства.Имя, ОписаниеСвойства.Тип);
		
	КонецЦикла;
	
	ТаблицаДанныхСообщенияОбмена.Индексы.Добавить("УникальныйИдентификатор");
	
	Возврат ТаблицаДанныхСообщенияОбмена;
	
КонецФункции

Функция ОбработкаДляЗагрузкиДанных()
	
	Возврат ПолеОбработкаДляЗагрузкиДанных;
	
КонецФункции

Функция ЭтоОбменЧерезВнешнееСоединение()
	
	Возврат ОбработкаДляЗагрузкиДанных() <> Неопределено;
	
КонецФункции

Процедура ПослеОткрытияФайлаЗагрузки(Отказ = Ложь, ИнициализироватьТаблицыПравил = Истина)
	
	ОбменДаннымиXDTOСервер.ПослеОткрытияФайлаЗагрузки(КомпонентыОбмена, Отказ, ИнициализироватьТаблицыПравил);
	
КонецПроцедуры

Процедура ПослеОткрытияФайлаВыгрузки(Отказ = Ложь)
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если КомпонентыОбмена.ТолькоНастройкиXDTO Тогда
		// Отправка настроек XDTO используется только для файловых каналов связи.
		КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Message
		КомпонентыОбмена.ФайлОбмена.Закрыть();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = "";
	Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
		ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(КомпонентыОбмена.УзелКорреспондента);
	КонецЕсли;
	
	Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена
		И ОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ОбработчикПроверкиОграниченийПередачиДанных", ИмяПланаОбмена) Тогда
		
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Корреспондент", КомпонентыОбмена.УзелКорреспондента);
		ПараметрыОбработчика.Вставить("ПоддерживаемыеОбъектыXDTO", КомпонентыОбмена.ПоддерживаемыеОбъектыXDTO);
		
		ПланыОбмена[ИмяПланаОбмена].ОбработчикПроверкиОграниченийПередачиДанных(Отказ, ПараметрыОбработчика, СообщениеОбОшибке);
		
		Если Отказ Тогда
			ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СообщениеОбОшибке);
			ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКодыУзлов(РезультатАнализаДанныхКЗагрузке, УзелИнформационнойБазы)
	
	Если Не ОбменДаннымиСервер.ЭтоПланОбменаXDTO(УзелИнформационнойБазы) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("ПланОбмена." + ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы));
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", УзелИнформационнойБазы);
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ПсевдонимыПредопределенныхУзлов");
		ЭлементБлокировкиДанных.УстановитьЗначение("Корреспондент", УзелИнформационнойБазы);
		
		БлокировкаДанных.Заблокировать();

		КодУзлаИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "Код");
		Если ЗначениеЗаполнено(РезультатАнализаДанныхКЗагрузке.NewFrom) Тогда
			УзелКорреспондентаПерекодирован = (КодУзлаИБ = РезультатАнализаДанныхКЗагрузке.NewFrom);
			Если Не УзелКорреспондентаПерекодирован
				И ОбменДаннымиXDTOСервер.ПоддерживаетсяВерсияСИдентификаторомОбменаДанными(УзелИнформационнойБазы) Тогда
				
				УзелОбменаОбъект = УзелИнформационнойБазы.ПолучитьОбъект();
				УзелОбменаОбъект.Код = РезультатАнализаДанныхКЗагрузке.NewFrom;
				УзелОбменаОбъект.ОбменДанными.Загрузка = Истина;
				УзелОбменаОбъект.Записать();
				
				УзелКорреспондентаПерекодирован = Истина;
			КонецЕсли;
		Иначе
			УзелКорреспондентаПерекодирован = Истина;
		КонецЕсли;
		
		Если УзелКорреспондентаПерекодирован Тогда
			ПсевдонимПредопределенногоУзла = ОбменДаннымиСервер.ПсевдонимПредопределенногоУзла(УзелИнформационнойБазы);
			Если ЗначениеЗаполнено(ПсевдонимПредопределенногоУзла)
				И РезультатАнализаДанныхКЗагрузке.КорреспондентПоддерживаетИдентификаторОбменаДанными Тогда
				// Возможно, пора удалить запись. Проверка секции To.
				ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
				КодПредопределенногоУзла = ОбменДаннымиСервер.КодПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена);
				Если СокрЛП(КодПредопределенногоУзла) = РезультатАнализаДанныхКЗагрузке.To Тогда
					ОбменДаннымиСлужебный.УдалитьНаборЗаписейВРегистреСведений(
						Новый Структура("Корреспондент", УзелИнформационнойБазы),
						"ПсевдонимыПредопределенныхУзлов");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

Параметры = Новый Структура;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли