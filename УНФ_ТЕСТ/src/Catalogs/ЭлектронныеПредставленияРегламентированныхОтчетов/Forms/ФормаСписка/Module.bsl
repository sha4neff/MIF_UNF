&НаСервере
Перем СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора;

&НаСервере
Перем ВыбранныеЭлементы;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.СписокКнопкаВыбрать.Видимость = Истина;
		Элементы.СписокКнопкаВыбрать.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.СписокКнопкаВыбрать.Видимость = Ложь;
	КонецЕсли;
	
	ИнициализироватьСоответствия();
	ВосстановитьЗначения();
	
	// пытаемся установить организацию по умолчанию
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		ОрганизацияПоУмолчанию = Модуль.ОрганизацияПоУмолчанию();
		
		Организация.Очистить();
		Организация.Добавить(ОрганизацияПоУмолчанию);
		
	Иначе
		ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
		УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
		Если ЗначениеЗаполнено(ОргПоУмолчанию) И НЕ УчетПоВсемОрганизациям Тогда
			Организация.Очистить();
			Организация.Добавить(ОргПоУмолчанию);
			Элементы.Организация.ТолькоПросмотр = Истина;
		ИначеЕсли Организация.Количество() = 0 И УчетПоВсемОрганизациям И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
			Организация.Добавить(ОргПоУмолчанию);
		КонецЕсли;
	КонецЕсли;
	
	УправлениеЭУДокументооборота();
	Если ЭлектронныйДокументооборотАктивен Тогда
		УстановитьОтборыЦО();
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "Организация");
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураПараметров = Новый Структура("Организация", Организация);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораОрганизаций", СтруктураПараметров, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПолучателяПриИзменении(Элемент)
	
	ТипФНС = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС");
	ТипПФР = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР");
	ТипФСС = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС");
	ТипФСГС = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСГС");
	ТипФСРАР = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР");
	ТипРПН = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН");
	ТипФТС = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС");
	
	Если ЗначениеЗаполнено(ТипПолучателя) Тогда
		
		МассивТипов = Новый Массив;
		
		Если ТипПолучателя = ТипФНС Тогда
			МассивТипов.Добавить(Тип("СправочникСсылка.НалоговыеОрганы"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		ИначеЕсли ТипПолучателя = ТипПФР Тогда
			МассивТипов.Добавить(Тип("СправочникСсылка.ОрганыПФР"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		ИначеЕсли ТипПолучателя = ТипФСС Тогда
			МассивТипов.Добавить(Тип("Строка"));
			ПараметрыСтроки = Новый КвалификаторыСтроки(4);
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов, , ПараметрыСтроки);
		ИначеЕсли ТипПолучателя = ТипФСГС Тогда
			МассивТипов.Добавить(Тип("СправочникСсылка.ОрганыФСГС"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		ИначеЕсли ТипПолучателя = ТипФСРАР Тогда
			МассивТипов.Добавить(Тип("Неопределено"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		ИначеЕсли ТипПолучателя = ТипРПН Тогда
			МассивТипов.Добавить(Тип("Неопределено"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		ИначеЕсли ТипПолучателя = ТипФТС Тогда
			МассивТипов.Добавить(Тип("Неопределено"));
			ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
		КонецЕсли;
		
		Элементы.Получатель.ОграничениеТипа = ДопустимыйТип;
		Получатель = ДопустимыйТип.ПривестиЗначение(Получатель);
		
		Элементы.Получатель.КнопкаВыбора 	= НЕ ТипПолучателя = ТипФСС И НЕ ТипПолучателя = ТипФСРАР И НЕ ТипПолучателя = ТипРПН И НЕ ТипПолучателя = ТипФТС;
		Элементы.Получатель.КнопкаОчистки 	= НЕ ТипПолучателя = ТипФСС И НЕ ТипПолучателя = ТипФСРАР И НЕ ТипПолучателя = ТипРПН И НЕ ТипПолучателя = ТипФТС;
		
	Иначе
		Элементы.Получатель.ОграничениеТипа = Новый ОписаниеТипов();
		Получатель = Неопределено;
	КонецЕсли;
	
	УстановитьОтборы();
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Организация.Количество() = 1 Тогда
		ПоказатьЗначение(, Организация.Получить(0).Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДополнительногоОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокВидовОтбораЦикловОбмена = Новый СписокЗначений;
	
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора = ПолучитьСоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора();
	
	Для Каждого ВидОтбора из СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора Цикл
		СписокВидовОтбораЦикловОбмена.Добавить(ВидОтбора.Ключ);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВидДополнительногоОтбораНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокВидовОтбораЦикловОбмена, , СписокВидовОтбораЦикловОбмена.НайтиПоЗначению(ВидДополнительногоОтбора));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка Тогда
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиОсновнойТаблицы", 0.3, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	КонтекстЭДОКлиент.ПолучениеФайловДляИмпортаНачало(УникальныйИдентификатор);
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦиклыОбменаФНСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	
	Результат = ВызватьВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, КолонкаВыбора, СтандартнаяОбработка);
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		ПоказатьЗначение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦиклыОбменаПредставлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить(
				"Ссылка", 
				Элемент.ТекущиеДанные.Ссылка);
	 
	КолонкаВыбора = Поле.Имя;
	
	Результат = ВызватьВыборВТабличномПолеЦикловОбмена(ДополнительныеПараметры, КолонкаВыбора, СтандартнаяОбработка);
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		ПоказатьЗначение(, Результат);
	Иначе
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦиклыОбменаЗаявлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	
	Результат = ВызватьВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, КолонкаВыбора, СтандартнаяОбработка);
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		ПоказатьЗначение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦиклыОбменаПФРВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	
	Результат = ВызватьВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, КолонкаВыбора, СтандартнаяОбработка);
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		ПоказатьЗначение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиФССВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	Если КолонкаВыбора = "ОтправкиФССРезультат" Тогда
		СтандартнаяОбработка = Ложь;
		КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточникаДляФСС(ВыбраннаяСтрока);
	ИначеЕсли КолонкаВыбора = "ОтправкиФССПервичноеСообщение" Тогда
		СтандартнаяОбработка = Ложь;
		Адрес = "";
		ИмяФайлаПакета = "";
		ПолучитьАдресИмяФайлаПакета(ВыбраннаяСтрока, Адрес, ИмяФайлаПакета, "ИмяФайлаПакета");
		ПолучитьФайл(Адрес, ИмяФайлаПакета);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиФСРАРВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	Если КолонкаВыбора = "ОтправкиФСРАРРезультат" Тогда
		СтандартнаяОбработка = Ложь;
		КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточникаДляФСРАР(ВыбраннаяСтрока);
	ИначеЕсли КолонкаВыбора = "ОтправкиФСРАРПервичноеСообщение" Тогда
		СтандартнаяОбработка = Ложь;
		Адрес = "";
		ИмяФайлаПакета = "";
		ПолучитьАдресИмяФайлаПакета(ВыбраннаяСтрока, Адрес, ИмяФайлаПакета, "ИмяФайлаПакета");
		ПолучитьФайл(Адрес, ИмяФайлаПакета);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦиклыОбменаФСГСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	
	Результат = ВызватьВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, КолонкаВыбора, СтандартнаяОбработка);
	Если ТипЗнч(Результат) = Тип("Строка") Тогда 
		ПоказатьПредупреждение(, Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
		ПоказатьЗначение(, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ЭлектронныеПредставленияРегламентированныхОтчетов", , Элемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиРПНВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	Если КолонкаВыбора = "ОтправкиРПНРезультат" Тогда
		СтандартнаяОбработка = Ложь;
		КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточникаДляРПН(ВыбраннаяСтрока);
	ИначеЕсли КолонкаВыбора = "ОтправкиРПНПервичноеСообщение" Тогда
		СтандартнаяОбработка = Ложь;
		Адрес = "";
		ИмяФайлаПакета = "";
		ПолучитьАдресИмяФайлаПакета(ВыбраннаяСтрока, Адрес, ИмяФайлаПакета, "ИмяФайлаПакета");
		ПолучитьФайл(Адрес, ИмяФайлаПакета);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиФТСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КолонкаВыбора = Поле.Имя;
	Если КолонкаВыбора = "ОтправкиФТСРезультат" Тогда
		СтандартнаяОбработка = Ложь;
		КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточникаДляФТС(ВыбраннаяСтрока);
	ИначеЕсли КолонкаВыбора = "ОтправкиФТСПервичноеСообщение" Тогда
		СтандартнаяОбработка = Ложь;
		Адрес = "";
		ИмяФайлаВыгрузки = "";
		ПолучитьАдресИмяФайлаПакета(ВыбраннаяСтрока, Адрес, ИмяФайлаВыгрузки, "ИмяФайлаВыгрузки");
		ПолучитьФайл(Адрес, НСтр("ru = 'Подпись'") + ИмяФайлаВыгрузки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСписокВыбрать(Команда)
	
	ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЖурналОбмена(Команда)
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.УправлениеОбменом");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтображатьПанельОбмена(Команда)
	
	Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка = НЕ Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка;
	УправлениеПоказомТаблицыЦикловОбмена();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеЭУ()
	
	Элементы.Получатель.Видимость = (ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР")
		И ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН")
		И ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	СохранитьЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДополнительногоОтбораНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		ВидДополнительногоОтбора = РезультатВыбора.Значение;
		УправлениеЭУ();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборы() Экспорт
	
	// управление отбором по организации
	Список.Отбор.Элементы.Очистить();
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ЭлементОтбора.Использование = Ложь;
	
	Если Организация.Количество() <> 0 Тогда
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = Организация;
	КонецЕсли;
	
	// управление отбором по типу получателя
	
	ЭлементОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипПолучателя");
	
	Если ЗначениеЗаполнено(ТипПолучателя) Тогда
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = ТипПолучателя;
	Иначе
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;
	
	// управление отбором по получателю
	ЭлементОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Получатель");
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = Получатель;
	Иначе
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;
	
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеПоказомТаблицыЦикловОбмена()
	
	Если Элементы.Найти("СписокКнопкаОтображатьПанельОбмена") <> Неопределено
		И Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка Тогда 
		Элементы.ЦиклыОбмена.Видимость = Истина;
	Иначе
		Элементы.ЦиклыОбмена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУДокументооборота()
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	ЭлектронныйДокументооборотАктивен = КонтекстЭДОСервер <> Неопределено
		И КонтекстЭДОСервер.ЭлектронныйДокументооборотИспользуется();
	
	Если НЕ ЭлектронныйДокументооборотАктивен Тогда
		
		Элементы.ЦиклыОбмена.Видимость = Ложь;
		Элементы.СписокКнопкаОтображатьПанельОбмена.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыЦО()
	
	// Устанавливаем параметры для произвольных запросов динамических списков
	// ФНС
	ТипыКолонка1ЦиклыОбмена = Новый Массив;
	ТипыКолонка1ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.ДекларацияНП);
	ТипыКолонка1ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.Форма2НДФЛНП);
	
	ТипыКолонка2ЦиклыОбмена = Новый Массив;
	ТипыКолонка2ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.ПодтверждениеДекларацияНО);
	ТипыКолонка2ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.ПодтверждениеФорма2НДФЛНО);
	
	ТипыКолонка4ЦиклыОбмена = Новый Массив;
	ТипыКолонка4ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.ИзвещениеДекларацияНО);
	ТипыКолонка4ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.ИзвещениеФорма2НДФЛНО);
	
	ТипыКолонка5ЦиклыОбмена = Новый Массив;
	ТипыКолонка5ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.РезультатПриемаДекларацияНО);
	ТипыКолонка5ЦиклыОбмена.Добавить(Перечисления.ТипыТранспортныхСообщений.РезультатПриемаФорма2НДФЛНО);
	
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка1", ТипыКолонка1ЦиклыОбмена);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка2", ТипыКолонка2ЦиклыОбмена);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка3", Перечисления.ТипыТранспортныхСообщений.ИзвещениеПодтверждениеНП);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка4", ТипыКолонка4ЦиклыОбмена);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка5", ТипыКолонка5ЦиклыОбмена);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка6", Перечисления.ТипыТранспортныхСообщений.ИзвещениеРезультатПриемаНП);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка7", Перечисления.ТипыТранспортныхСообщений.РезультатОбработкиДекларацияНО);
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("ТипКолонка8", Перечисления.ТипыТранспортныхСообщений.ИзвещениеРезультатОбработкиНП);
	
	ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);
	
	// ПФР
	ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("ТипКолонкаПФР1", Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееОтчетностьПФР);
	ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("ТипКолонкаПФР4", Перечисления.ТипыТранспортныхСообщений.ПодтверждениеПолученияОтчетностиПФР);
	ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("ТипКолонкаПФР5", Перечисления.ТипыТранспортныхСообщений.ПротоколПФР);
	ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("ТипКолонкаПФР6", Перечисления.ТипыТранспортныхСообщений.ПротоколКвитанцияПФР);
	
	ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);
	
	ОтправкиФСС.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", Неопределено);
	
	ОтправкиФСРАР.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", Неопределено);
	
	ОтправкиРПН.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", Неопределено);
	
	ОтправкиФТС.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", Неопределено);
	
	// Росстат
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС1", Перечисления.ТипыТранспортныхСообщений.ПервичноеСообщениеСодержащееОтчетностьФСГС);
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС2", Перечисления.ТипыТранспортныхСообщений.ПодтверждениеДатыОтправкиФСГС);
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС3", Перечисления.ТипыТранспортныхСообщений.ИзвещениеПодтверждениеДатыОтправкиФСГС);
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС4", Перечисления.ТипыТранспортныхСообщений.ИзвещениеОПолученииОтчетностиФСГС);
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС5", Перечисления.ТипыТранспортныхСообщений.ПротоколВходногоКонтроляОтчетностиФСГС);
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("ТипКолонкаФСГС6", Перечисления.ТипыТранспортныхСообщений.ИзвещениеПротоколВходногоКонтроляОтчетностиФСГС);
	
	ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);

	// Заявление
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка1", Перечисления.ТипыТранспортныхСообщений.ЗаявлениеНП);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка2", Перечисления.ТипыТранспортныхСообщений.ПодтверждениеЗаявлениеНО);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка3", Перечисления.ТипыТранспортныхСообщений.ИзвещениеПодтверждениеНП);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка4", Перечисления.ТипыТранспортныхСообщений.ИзвещениеЗаявлениеНО);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка5", Перечисления.ТипыТранспортныхСообщений.РезультатПриемаЗаявлениеНО);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка6", Перечисления.ТипыТранспортныхСообщений.ИзвещениеРезультатПриемаНП);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка7", Перечисления.ТипыТранспортныхСообщений.РезультатОбработкиЗаявлениеРФНО);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка8", Перечисления.ТипыТранспортныхСообщений.ИзвещениеРезультатОбработкиРФНП);
	
	ПараметрыКолонки = Новый Массив;
	ПараметрыКолонки.Добавить(Перечисления.ТипыТранспортныхСообщений.СообщениеОбОтзывеЗаявлениеРФНО);
	ПараметрыКолонки.Добавить(Перечисления.ТипыТранспортныхСообщений.РезультатОбработкиЗаявлениеТСНО);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка9", ПараметрыКолонки);
	
	ПараметрыКолонки = Новый Массив;
	ПараметрыКолонки.Добавить(Перечисления.ТипыТранспортныхСообщений.ИзвещениеОбОтзывеЗаявлениеРФНП);
	ПараметрыКолонки.Добавить(Перечисления.ТипыТранспортныхСообщений.ИзвещениеРезультатОбработкиТСНП);
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("ТипКолонка10", ПараметрыКолонки);
	
	ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);
	
	//Представление (уведомление)
	ЦиклыОбменаПредставление.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиОсновнойТаблицы()
	
	Если НЕ ЭлектронныйДокументооборотАктивен Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.Список.ТекущаяСтрока;
	ТекДанные_ТипПолучателя = Неопределено;
	
	Если ТекДанные <> Неопределено Тогда
		
		ТекДанные_Реквизиты = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЗначенияРеквизитовОбъекта(ТекДанные,
			"ТипПолучателя, ВидОтчета");
		ТекДанные_ТипПолучателя = ТекДанные_Реквизиты.ТипПолучателя;
		ТекДанные_ВидОтчета = ТекДанные_Реквизиты.ВидОтчета;
		
		Если ТипЗнч(ТекДанные_ВидОтчета) = Тип("СправочникСсылка.ВидыОтправляемыхДокументов") Тогда
			ТекДанные_ВидОтчета_ТипДокумента = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЗначенияРеквизитовОбъекта(ТекДанные_ВидОтчета,
			"ТипДокумента").ТипДокумента;
		Иначе
			ТекДанные_ВидОтчета_ТипДокумента = Неопределено;
		КонецЕсли;
		
		ТекДанные_Ссылка = ТекДанные;
		
	КонецЕсли;
	
	// определяем, циклы обмена с каким КО будут отображаться
	Если ТекДанные = Неопределено
		ИЛИ
		(ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОВвозеТоваров")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПереченьЗаявленийОВвозеТоваров")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.УведомлениеОРозничныхЦенахНаТабачныеИзделия")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.СтрановойОтчет")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.УчастиеВМеждународнойГруппеКомпаний")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ДоходыОтДеятельностиМузеяТеатраБиблиотеки")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ДвижениеСредствПоСчетуВБанкеЗаПределамиРФ")
		И ТекДанные_ВидОтчета <> ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСДокументыДляКомпенсацииНалога")
		И ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС")
		И ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР")
		И ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН")
		И ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС")
		И ТекДанные_ТипПолучателя <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСГС")
		И ТекДанные_ВидОтчета_ТипДокумента <> ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.ИсходящееУведомлениеФНС")
		И ТекДанные_ВидОтчета_ТипДокумента <> ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.УведомлениеОКонтролируемыхСделках")
		И ТекДанные_ВидОтчета_ТипДокумента <> ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.УведомлениеОРозничныхЦенахНаТабак")
		И НЕ ДокументооборотСКОКлиентСервер.ЭтоВидОтправляемогоДокументаРеестраНДС(ТекДанные_ВидОтчета)
		И НЕ ДокументооборотСКОКлиентСервер.ЭтоВидОтправляемогоДокументаРеестраАкцизов(ТекДанные_ВидОтчета)) Тогда
		
		// отображаются циклы обмена с ФНС
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаЦиклыОбменаФНС;
		
		Если ТекДанные = Неопределено Тогда 
			ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("Предмет", Неопределено);
		Иначе 
			ЦиклыОбменаФНС.Параметры.УстановитьЗначениеПараметра("Предмет", ТекДанные_Ссылка);
		КонецЕсли;
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаЦиклыОбменаПФР;
		
		ЦиклыОбменаПФР.Параметры.УстановитьЗначениеПараметра("Предмет", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОВвозеТоваров") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаЦиклыОбменаЗаявление;
		
		ЦиклыОбменаЗаявление.Параметры.УстановитьЗначениеПараметра("Предмет", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ВидОтчета_ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.ИсходящееУведомлениеФНС")
		ИЛИ ТекДанные_ВидОтчета_ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.УведомлениеОКонтролируемыхСделках")
		ИЛИ ТекДанные_ВидОтчета_ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОтправляемыхДокументов.УведомлениеОРозничныхЦенахНаТабак")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПереченьЗаявленийОВвозеТоваров")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.СтрановойОтчет")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.УчастиеВМеждународнойГруппеКомпаний")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ДоходыОтДеятельностиМузеяТеатраБиблиотеки")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ДвижениеСредствПоСчетуВБанкеЗаПределамиРФ")
		ИЛИ ТекДанные_ВидОтчета = ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСДокументыДляКомпенсацииНалога")
		ИЛИ ДокументооборотСКОКлиентСервер.ЭтоВидОтправляемогоДокументаРеестраНДС(ТекДанные_ВидОтчета)
		ИЛИ ДокументооборотСКОКлиентСервер.ЭтоВидОтправляемогоДокументаРеестраАкцизов(ТекДанные_ВидОтчета) Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаЦиклыОбменаПредставление;
		
		ЦиклыОбменаПредставление.Параметры.УстановитьЗначениеПараметра("Предмет", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаОтправкиФСС;
		
		ОтправкиФСС.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаОтправкиФСРАР;
		
		ОтправкиФСРАР.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаОтправкиРПН;
		
		ОтправкиРПН.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаОтправкиФТС;
		
		ОтправкиФТС.Параметры.УстановитьЗначениеПараметра("ОтчетСсылка", ТекДанные_Ссылка);
		
	ИначеЕсли ТекДанные_ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСГС") Тогда
		
		Элементы.ЦиклыОбмена.ТекущаяСтраница = Элементы.ГруппаЦиклыОбменаФСГС;
		
		ЦиклыОбменаФСГС.Параметры.УстановитьЗначениеПараметра("Предмет", ТекДанные_Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВызватьВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, Колонка, СтандартнаяОбработка) Экспорт
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Возврат КонтекстЭДОСервер.ВыборВТабличномПолеЦикловОбмена(ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьАдресИмяФайлаПакета(ОтправкаСсылка, Адрес, ИмяФайлаПакета, ИмяРеквизита)
	
	МетаданныеОбъекта = ОтправкаСсылка.Метаданные();
	Если МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		ИмяФайлаПакета = ОтправкаСсылка[ИмяРеквизита];
	КонецЕсли;
	Если ТипЗнч(ОтправкаСсылка) <> Тип("СправочникСсылка.ОтправкиФТС") Тогда
		Адрес = ПоместитьВоВременноеХранилище(ОтправкаСсылка.ЗашифрованныйПакет.Получить());
	Иначе
		Адрес = ПоместитьВоВременноеХранилище(ОтправкаСсылка.Подпись.Получить());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСоответствия()
	
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора = Новый Соответствие;
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По виду отчета", Элементы.ПоВидуОтчета);
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По периоду отчета", Элементы.ПоПериодуОтчета);
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По виду документа", Элементы.ПоВидуДокумента);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора()
	
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора = Новый Соответствие;
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По виду отчета", Элементы.ПоВидуОтчета);
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По периоду отчета", Элементы.ПоПериодуОтчета);
	СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора.Вставить("По виду документа", Элементы.ПоВидуДокумента);
	
	Возврат СоответствиеВидаОтбораЦикловОбменаСтраницеПанелиОтбора;
	
КонецФункции

&НаСервере
Процедура ВосстановитьЗначения()
	
	// восстанавливаем организацию
	сохрОрганизация = ХранилищеОбщихНастроек.Загрузить("ЭлектронныеПредставленияРегламентированныхОтчетов_Организация");
	Если ТипЗнч(сохрОрганизация) = Тип("Массив") Тогда
		Организация.ЗагрузитьЗначения(сохрОрганизация);
	ИначеЕсли ТипЗнч(сохрОрганизация) = Тип("СписокЗначений") Тогда
		Организация = сохрОрганизация;
	КонецЕсли;
	
	// восстанавливаем тип получателя
	сохрТипПолучателя = ХранилищеОбщихНастроек.Загрузить("ЭлектронныеПредставленияРегламентированныхОтчетов_ТипПолучателя");
	Если сохрТипПолучателя <> Неопределено Тогда
		ТипПолучателя = сохрТипПолучателя;
	КонецЕсли;
	
	// восстанавливаем получателя
	сохрПолучатель = ХранилищеОбщихНастроек.Загрузить("ЭлектронныеПредставленияРегламентированныхОтчетов_Получатель");
	Если сохрПолучатель <> Неопределено Тогда
		Получатель = сохрПолучатель;
	КонецЕсли;
	
	ОтображатьПанельОбмена = ХранилищеНастроекДанныхФорм.Загрузить("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов.Форма.ФормаСписка", "ФормаЭлПредстРеглОтчетов_ОтображатьПанельОбмена");
	Если ОтображатьПанельОбмена <> Неопределено Тогда
		Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка = ОтображатьПанельОбмена;
	КонецЕсли;
	Элементы.ЦиклыОбмена.Видимость = Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначения()
	
	ХранилищеОбщихНастроек.Сохранить("ЭлектронныеПредставленияРегламентированныхОтчетов_Организация",, Организация);
	ХранилищеОбщихНастроек.Сохранить("ЭлектронныеПредставленияРегламентированныхОтчетов_ТипПолучателя",, ТипПолучателя);
	ХранилищеОбщихНастроек.Сохранить("ЭлектронныеПредставленияРегламентированныхОтчетов_Получатель",, Получатель);
	ХранилищеНастроекДанныхФорм.Сохранить("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов.Форма.ФормаСписка", "ФормаЭлПредстРеглОтчетов_ОтображатьПанельОбмена", Элементы.СписокКнопкаОтображатьПанельОбмена.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
		
	ПоказатьПериод();
	УправлениеЭУ();
	УстановитьОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеНадписямиМесяцев()
	
	Месяц = Месяц(ДатаКонцаПериодаОтбора);
	Для Сч = 0 По 11 Цикл
		Если Сч = Месяц - 1 Тогда
			Элементы["НадписьМесяц" + (Сч + 1)].ЦветТекста = Новый Цвет(0, 0, 255);
		Иначе
			Элементы["НадписьМесяц" + (Сч + 1)].ЦветТекста = Новый Цвет();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПериод()

	Год = Год(ДатаКонцаПериодаОтбора);
	МесяцМинус1 = Месяц(ДатаКонцаПериодаОтбора) - 1;
	УправлениеНадписямиМесяцев();

КонецПроцедуры

#КонецОбласти

