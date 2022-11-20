///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("ПараметрыОткрытияФормыОтчета", ПараметрыОткрытияФормыОтчета) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Доступен = ?(Объект.ТолькоДляАвтора, "ТолькоДляАвтора", "УказаннымПользователям");
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	ПравоНаЭтотВариант = ПолныеПраваНаВарианты Или Объект.Автор = Пользователи.АвторизованныйПользователь();
	Если Не ПравоНаЭтотВариант Тогда
		ТолькоПросмотр = Истина;
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Объект.ПометкаУдаления Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не Объект.Пользовательский Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Доступен.ТолькоПросмотр = Истина;
		Элементы.Автор.ТолькоПросмотр = Истина;
		Элементы.Автор.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	ЭтоВнешний = (Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Если ЭтоВнешний Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.Доступен.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.Автор.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.ТехническаяИнформация.Видимость = ПолныеПраваНаВарианты;
	
	// Заполнение имени отчета для команды "Просмотр".
	Если Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внутренний
		Или Объект.ТипОтчета = Перечисления.ТипыОтчетов.Расширение Тогда
		ИмяОтчета = Объект.Отчет.Имя;
	ИначеЕсли Объект.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда
		ИмяОтчета = Объект.Отчет.ИмяОбъекта;
	Иначе
		ИмяОтчета = Объект.Отчет;
	КонецЕсли;
	
	ПерезаполнитьДерево(Ложь);
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	
	ВариантыОтчетов.ОпределитьПоведениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПараметрыОткрытияФормыОтчета <> Неопределено Тогда
		Отказ = Истина;
		ВариантыОтчетовКлиент.ОткрытьФормуОтчета(Неопределено, ПараметрыОткрытияФормыОтчета);
	КонецЕсли;
	
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник <> ЭтотОбъект
		И (ИмяСобытия = ВариантыОтчетовКлиент.ИмяСобытияИзменениеВарианта()
			Или ИмяСобытия = "Запись_НаборКонстант") Тогда
		ПерезаполнитьДерево(Истина);
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Запись свойств, связанных с предопределенным вариантом отчета.
	ОписаниеИзменено = Ложь;
	Если ЭтоПредопределенный Тогда
		
		ПредопределенныйВариант = ТекущийОбъект.ПредопределенныйВариант.ПолучитьОбъект();
		МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ПредопределенныйВариант);
		
		ОписаниеИзменено = Не ПустаяСтрока(Объект.Описание) И НРег(СокрЛП(Объект.Описание)) <> НРег(СокрЛП(ПредопределенныйВариант.Описание));
		Если Не ОписаниеИзменено Тогда
			ТекущийОбъект.Описание = "";
			Для каждого ПредставлениеВарианта Из ТекущийОбъект.Представления Цикл 
				ПредставлениеВарианта.Описание = "";
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
	// Запись дерева подсистем.
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	Если ТекущийОбъект.ЭтоНовый() Тогда
		ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
	Иначе
		ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
	КонецЕсли;
	ВариантыОтчетов.ДеревоПодсистемЗаписать(ТекущийОбъект, ИзмененныеРазделы);
	
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	Если ЭтоПредопределенный И Не ОписаниеИзменено Тогда
		ТекущийОбъект.Представления.Очистить();
	КонецЕсли;
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПользователиВарианта", ПользователиВарианта);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ПерезаполнитьДерево(Ложь);
	ЗаполнитьИзПредопределенного(ТекущийОбъект);
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы(Объект.Ссылка, ЭтотОбъект);
	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтотОбъект, "ДеревоПодсистем", "*", Истина);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьИзПредопределенного(ТекущийОбъект);
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	РегистрыСведений.НастройкиВариантовОтчетов.ПрочитатьНастройкиДоступностиВариантаОтчета(
		ТекущийОбъект.Ссылка, ПользователиВарианта, ИспользоватьГруппыПользователей, ИспользоватьВнешнихПользователей);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Описание", НСтр("ru = 'Описание'"));
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	
	Объект.ТолькоДляАвтора = (Доступен = "ТолькоДляАвтора");
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиВарианта

&НаКлиенте
Процедура ПользователиВариантаПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередУдалением(Элемент, Отказ)
	
	Если Не ИспользоватьГруппыПользователей
		И Не ИспользоватьВнешнихПользователей Тогда 
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВариантыОтчетовКлиент.ПользователиВариантаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПометкаПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ВариантыОтчетовКлиент.ПодобратьПользователейВариантаОтчета(
		ЭтотОбъект, Элементы.ПользователиВариантаГруппаПодобрать.Видимость);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьГруппыВнешнихПользователей(Команда)
	
	ВариантыОтчетовКлиент.ПодобратьПользователейВариантаОтчета(
		ЭтотОбъект, Элементы.ПользователиВариантаГруппаПодобрать.Видимость, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ВариантыОтчетов.УстановитьУсловноеОформлениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	ВариантыОтчетов.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПерезаполнитьДерево(Прочитать)
	ВыделенныеСтроки = ОтчетыСервер.ЗапомнитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", "Ссылка");
	Если Прочитать Тогда
		ЭтотОбъект.Прочитать();
	КонецЕсли;
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, Объект);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
	ОтчетыСервер.ВосстановитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", ВыделенныеСтроки);
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ЗаполнитьИзПредопределенного(ВариантОбъект)
	
	ЭтоПредопределенный = ВариантыОтчетов.ЭтоПредопределенныйВариантОтчета(ВариантОбъект);
	
	Если Не ЭтоПредопределенный Тогда
		Возврат;
	КонецЕсли;
	
	ПредопределенныйВариант = ВариантОбъект.ПредопределенныйВариант.ПолучитьОбъект();
	
	ВариантОбъект.Наименование = ПредопределенныйВариант.Наименование;
	
	ПредставленияВарианта = ВариантОбъект.Представления.Выгрузить();
	ВариантОбъект.Представления.Очистить();
	ВариантОбъект.Представления.Загрузить(ПредопределенныйВариант.Представления.Выгрузить());
	
	Если ПустаяСтрока(ВариантОбъект.Описание) Тогда
		ВариантОбъект.Описание = ПредопределенныйВариант.Описание;
	Иначе
		ВариантОбъект.Представления.Сортировать("КодЯзыка");
		ПредставленияВарианта.Сортировать("КодЯзыка");
		Для каждого ПредставлениеВарианта Из ВариантОбъект.Представления Цикл
			ОписаниеВарианта = ПредставленияВарианта.Найти(ПредставлениеВарианта.КодЯзыка, "КодЯзыка");
			ПредставлениеВарианта.Описание = ОписаниеВарианта.Описание;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
