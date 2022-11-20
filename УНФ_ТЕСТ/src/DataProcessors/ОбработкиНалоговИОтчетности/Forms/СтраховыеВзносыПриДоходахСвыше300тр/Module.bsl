#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Если ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		Иначе
			Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация =УправлениеНебольшойФирмойСервер.ПолучитьПредопределеннуюОрганизацию();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СобытиеКалендаря) Тогда
		Объект.СобытиеКалендаря = Параметры.СобытиеКалендаря;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СостояниеСобытия) Тогда
		
		Если ЗначениеЗаполнено(Параметры.СостояниеСобытия) Тогда
			
			Объект.СостояниеСобытия = Параметры.СостояниеСобытия;
			
		Иначе
			
			Объект.СостояниеСобытия = КалендарьОтчетности.ПолучитьСостояниеСобытияКалендаря(
				Объект.Организация,
				Объект.СобытиеКалендаря);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДатыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СобытиеКалендаря, "ДатаДокументаОбработкиСобытия,ДатаНачалаДокументов,ДатаОкончанияДокументов");
	ДатаДокументаОбработкиСобытия = ДатыСобытия.ДатаДокументаОбработкиСобытия;
	ДатаОкончанияДокументов = ДатыСобытия.ДатаОкончанияДокументов;
	
	ПолучитьДанныеОтчетности();
	
	Элементы.ГруппаУплатыЧерезБанкОписание.Видимость = Ложь;
	Элементы.ГруппаУплатыЧерезКассуОписание.Видимость = Ложь;
	
	
	
	ПериодЗадачиПредставление = ПредставлениеПериода(
		ДатыСобытия.ДатаНачалаДокументов,
		КонецДня(ДатыСобытия.ДатаОкончанияДокументов),
		"ФП=Истина");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Ознакомиться") Тогда
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.РезультатРасчета;
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Уплатить") Тогда
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.УплатаНалога;
		
	Иначе
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
		
	КонецЕсли;
	
	
	УстановитьВидимостьИДоступностьЭлементов();
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// -----------------------------------------------------------------------------
// квитанция

&НаКлиенте
Процедура ДекорацияВсеПлатежкиНажатие(Элемент)
	
	Если ПФРСвыше300тр = "0,00 р." Тогда
		ПоказатьПредупреждение(,НСтр("ru='Сумма нулевая. Уплата не требуется.'"));
		Возврат;
	КонецЕсли;
	
	оп = Новый ОписаниеОповещения("ПолучениеДанныхПлатежек", ЭтотОбъект, Новый Структура("Файл", Ложь));
	ПолучитьСписокПлатежек(оп);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеФайлыНажатие(Элемент)
	
	Если ПФРСвыше300тр = "0,00 р." Тогда
		ПоказатьПредупреждение(,НСтр("ru='Сумма нулевая. Уплата не требуется.'"));
		Возврат;
	КонецЕсли;
	
	оп = Новый ОписаниеОповещения("ПолучениеДанныхПлатежек", ЭтотОбъект, Новый Структура("Файл", Истина));
	ПолучитьСписокПлатежек(оп);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеДанныхПлатежек(БанкСчетСтруктура, Параметры) Экспорт
	
	Если Параметры.Файл Тогда
		Если ПроверитьНаличиеГосОргана("ПолучитьФайлКлиентБанка") Тогда
			ПолучитьСписокПлатежекНаСервере();
			СписокПлатежек = Новый СписокЗначений;
			Если ПФРСвыше300тр <> "0,00 р." Тогда
				СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРСтраховая);
			КонецЕсли;
			
			БанкСчетСтруктура.Вставить("СписокПлатежек", СписокПлатежек);
			ОткрытьФорму(
				"Обработка.КлиентБанк.Форма.СохранениеПлатежек", БанкСчетСтруктура, , , , , ,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	Иначе
		Если ПроверитьНаличиеГосОргана("РаспечататьПлатежноеПоручениеЗавершение") Тогда
			РаспечататьПлатежноеПоручениеЗавершение();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеКвитанцииНажатие(Элемент)
	
	Если ПФРСвыше300тр = "0,00 р." Тогда
		ПоказатьПредупреждение(,НСтр("ru='Сумма нулевая. Уплата не требуется.'"));
		Возврат;
	КонецЕсли;
	
	Если ПроверитьНаличиеГосОргана("РаспечататьКвитанциюЗавершение") Тогда
		РаспечататьКвитанциюЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходовУСНСвыше300трНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПериодПараметр = КалендарьОтчетностиПовтИсп.ПолучитьСтандартныйПериодДокументовДляСобытия(Объект.СобытиеКалендаря);
	
	ОткрытьФорму("Отчет.ДоходыРасходы.ФормаОбъекта",
		Новый Структура("Организация,СформироватьПриОткрытии, Период,ВидОтчета", Объект.Организация, Истина,
		ПериодПараметр, "Доходы"));
		
КонецПроцедуры

&НаКлиенте
Процедура УплаченоСНачалоГОДСвыше300трНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПериодПараметр = КалендарьОтчетностиПовтИсп.ПолучитьСтандартныйПериодДокументовДляСобытия(Объект.СобытиеКалендаря);
	
	СпсВидов = Новый СписокЗначений;
	СпсВидов.Добавить(ПредопределенноеЗначение("Справочник.ВидыНалогов.ПФРСвыше300тр"));
	
	СпсЗадач = Новый СписокЗначений;
	СпсЗадач.Добавить(ПредопределенноеЗначение(
		"Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300тр"));
	
	ОткрытьФорму("Отчет.УплатыНалоговИВзносов.ФормаОбъекта",
		Новый Структура("Организация, СформироватьПриОткрытии, Период,ВидВзаиморасчетов, УчетВыплатТекущегоГода, ЗадачиКалендаря",
		Объект.Организация, Истина, ПериодПараметр, СпсВидов, Ложь, СпсЗадач));
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходовЕНВДСвыше300трНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(
		"Обработка.ОбработкиНалоговИОтчетности.Форма.ТаблицаЕНВДРасшифровка",
		Новый Структура(
			"АдресОбщейТаблицы,ПолнаяТаблица,ПоказатьДоходыИКвартал",
			АдресТаблицаЕНВД,
			Истина, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходовПатентСвыше300трНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(
		"Обработка.ОбработкиНалоговИОтчетности.Форма.ТаблицаПатентРасшифровка",
		Новый Структура(
			"Организация,НачалоПериода,ОкончаниеПериода",
			Объект.Организация,
			НачалоГода(ДатаОкончанияДокументов), КонецДня(ДатаОкончанияДокументов)));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// -----------------------------------------------------------------------------
// События переходов

&НаКлиенте
Процедура ПереходЗаполнение(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Заполнить");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		"");
	
	ПараметрыФормы = Новый Структура("Организация,СобытиеКалендаря", Объект.Организация,Объект.СобытиеКалендаря);
	
	КалендарьОтчетностиКлиент.ОткрытьФормуНачалаЗаполнения(ЭтаФорма,ПараметрыФормы);
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходУплата(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Уплатить");
	
	ЗафиксироватьПереходкУплате(Объект.Организация, Объект.СобытиеКалендаря, Объект.СостояниеСобытия, ВсегоКУплатеВПФР);
	
	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.УплатаНалога;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗафиксироватьПереходкУплате(Организация, Событие, Состояние, ВсегоКУплате)
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Организация,
		Событие,
		Состояние,
		ВсегоКУплате);
	
	
	ЗаписьКалендаря = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьЗаписьКалендаря(Организация, Событие);
	Если ЗаписьКалендаря <> Неопределено Тогда
		ОбъектЗаписьКалендаря = ЗаписьКалендаря.ПолучитьОбъект();
		ОбъектЗаписьКалендаря.Завершено = Ложь;
		ОбъектЗаписьКалендаря.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходРезультатРасчета(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Ознакомиться");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		ВсегоКУплатеВПФР);
	
	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.РезультатРасчета;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходВыполнил(Команда)
	
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершено");
	
	КалендарьОтчетности.ЗавершитьСобытиеКалендаряОтчетности(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		"");
	
	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности"));
	Оповестить("Запись_ЗаписиКалендаряПодготовкиОтчетности");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьРасходыВПрограмме(Команда)
	
	Если ВсегоКУплатеВПФР = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='Сумма нулевая. Уплата не требуется.'"));
		Возврат;
	КонецЕсли;
	
	Список = Новый СписокЗначений;
	
	Список.Добавить(ДокументВзаиморасчетовСБюджетомПФРСтраховая,НСтр("ru='ПФР'"));
	
	ДанныеПоНачислениям = Новый Массив;
	ДанныеПоНачислениям.Добавить(Новый Структура("НачислениеНалогов,Сумма,Представление",
		ДокументВзаиморасчетовСБюджетомПФРСтраховая, ВсегоКУплатеВПФР, НСтр("ru='ПФР'")));

	ОткрытьФорму(
		"Обработка.ОбработкиНалоговИОтчетности.Форма.ГрупповаяРегистрацияРасходов",
		Новый Структура("Организация,СписокКПоиску,ДанныеПоНачислениям", Объект.Организация, Список,
		ДанныеПоНачислениям));
	
КонецПроцедуры

&НаКлиенте
Процедура Пересчитать(Команда)
	ОбновитьРасчет();
КонецПроцедуры

&НаКлиенте
Процедура УплатаЧерезБанк(Команда)
	Элементы.ГруппаУплатыЧерезБанкОписание.Видимость = Истина;
	Элементы.ГруппаУплатыЧерезКассуОписание.Видимость = Ложь;
	Элементы.УплатаЧерезБанк.Шрифт = Новый Шрифт(Элементы.УплатаЧерезБанк.Шрифт, , , Истина);
	Элементы.УплатаЧерезКассу.Шрифт = Новый Шрифт(Элементы.УплатаЧерезКассу.Шрифт, , , Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УплатаЧерезКассу(Команда)
	Элементы.ГруппаУплатыЧерезБанкОписание.Видимость = Ложь;
	Элементы.ГруппаУплатыЧерезКассуОписание.Видимость = Истина;
	Элементы.УплатаЧерезБанк.Шрифт = Новый Шрифт(Элементы.УплатаЧерезБанк.Шрифт, , , Ложь);
	Элементы.УплатаЧерезКассу.Шрифт = Новый Шрифт(Элементы.УплатаЧерезКассу.Шрифт, , , Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок()
	
	ИмяКнопки = ПолучитьИмяЭлементаКнопкиПоУмолчанию(Элементы.СтраницаВзносыВПФР.ТекущаяСтраница.Имя);
	
	Если НЕ ПустаяСтрока(ИмяКнопки) Тогда
		Элементы[ИмяКнопки].КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.СтраницаВзносыВПФР.ТекущаяСтраница.Заголовок, ПериодЗадачиПредставление);
	РегламентированнаяОтчетностьУСНКлиентСервер.УстановитьЗаголовокФормыЗадачи(ЭтаФорма, Объект.Организация);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяЭлементаКнопкиПоУмолчанию(ИмяСтраницы)
	
	Если ИмяСтраницы = "РезультатРасчета" Тогда
		Возврат "ПереходДалее";
	ИначеЕсли ИмяСтраницы = "УплатаНалога" Тогда
		Возврат "ПереходВыполнил";
	ИначеЕсли ИмяСтраницы = "ЗадачаВыполнена" Тогда
		Возврат "";
	Иначе
		ВызватьИсключение НСтр("ru='Неизвестное имя текущей страницы'");
	КонецЕсли;
	
КонецФункции

// Процедура заполняет данные формы по данным ранее сформированной отчетности
//
&НаСервере
Процедура ПолучитьДанныеОтчетности()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗначенияПоказателейОтчетности.ЗначениеПоказателя КАК ЗначениеПоказателя,
	|	ЗначенияПоказателейОтчетности.ПоказательОтчетности.Код КАК КодОтчетности,
	|	ЗначенияПоказателейОтчетности.ПоказательОтчетности
	|ИЗ
	|	РегистрСведений.ЗначенияПоказателейОтчетности КАК ЗначенияПоказателейОтчетности
	|ГДЕ
	|	ЗначенияПоказателейОтчетности.Организация = &Организация
	|	И ЗначенияПоказателейОтчетности.ПериодОтчетности = &ПериодОтчетности
	|	И ЗначенияПоказателейОтчетности.ПоказательОтчетности В ИЕРАРХИИ(&ГруппаПоказателя)");
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ПериодОтчетности", ДатаДокументаОбработкиСобытия);
	
	Запрос.УстановитьПараметр("ГруппаПоказателя", ПланыВидовХарактеристик.ПоказателиОтчетности.ВзносыВПФРСвыше300тр);
	
	Выборка = Запрос.Выполнить().Выбрать();
	ДоходыУСН = 0;
	ДоходыЕНВД = 0;
	ДоходыПатент = 0;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ПоказательОтчетности = ПланыВидовХарактеристик.ПоказателиОтчетности.СуммаДоходовУСНСвыше300тр Тогда
			ДоходыУСН = Выборка.ЗначениеПоказателя;
		ИначеЕсли Выборка.ПоказательОтчетности = ПланыВидовХарактеристик.ПоказателиОтчетности.СуммаДоходовЕНВДСвыше300тр Тогда
			ДоходыЕНВД = Выборка.ЗначениеПоказателя;
		ИначеЕсли Выборка.ПоказательОтчетности = ПланыВидовХарактеристик.ПоказателиОтчетности.СуммаДоходовПатентСвыше300тр Тогда
			ДоходыПатент = Выборка.ЗначениеПоказателя;
		ИначеЕсли Выборка.ПоказательОтчетности = ПланыВидовХарактеристик.ПоказателиОтчетности.хзТаблицаЕНВДСвыше300тр Тогда
			
			Табличка = РегламентированнаяОтчетностьУСН.ПолучитьЗначениеПроизвольногоПоказателя(
				Объект.Организация,
				ДатаДокументаОбработкиСобытия,
				ПланыВидовХарактеристик.ПоказателиОтчетности.хзТаблицаЕНВДСвыше300тр);
			
			Если Табличка = Неопределено Тогда
				ЗаписьЖурналаРегистрации(
					НСтр("ru='ЕНВД.Заполнение задачи'"),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					НСтр("ru='Не удалось получить данные для ТаблицаЕНВД'"));
			Иначе
				АдресТаблицаЕНВД = ПоместитьВоВременноеХранилище(Табличка,УникальныйИдентификатор);
			КонецЕсли;
			
			Продолжить;
		ИначеЕсли Выборка.ПоказательОтчетности = ПланыВидовХарактеристик.ПоказателиОтчетности.ПФРСвыше300тр Тогда
			ВсегоКУплатеВПФР = Выборка.ЗначениеПоказателя;
		КонецЕсли;
		
		ЭтаФорма[Выборка.КодОтчетности] = Формат(Выборка.ЗначениеПоказателя, "ЧДЦ=2; ЧРГ=; ЧН=" ) + " р.";
	КонецЦикла;
	Если ПустаяСтрока(СуммаДоходовПатентСвыше300тр) Тогда
		СуммаДоходовПатентСвыше300тр = "0,00 р."
	КонецЕсли;
	
	СуммаДоходовВсего = Формат(ДоходыУСН + ДоходыЕНВД + ДоходыПатент, "ЧДЦ=2; ЧРГ=; ЧН=" ) + " р.";
	
	НайтиДокументыВзаиморасчетаСбюджетом();
	НайтиДокументОплаты();
	
	
КонецПроцедуры

&НаСервере
Процедура НайтиДокументОплаты()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходДенежныхСредствИзКассы.Ссылка
	|ИЗ
	|	Документ.РасходИзКассы КАК РасходДенежныхСредствИзКассы
	|ГДЕ
	|	РасходДенежныхСредствИзКассы.Организация = &Организация
	|	И РасходДенежныхСредствИзКассы.ДокументОснование = &ДокументОснование
	|	И РасходДенежныхСредствИзКассы.Проведен
	|");
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументВзаиморасчетовСБюджетомПФРСтраховая);
	
	// ПФР Накопительная
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СсылкаДокументаНаличнойОплатыПФРСтраховая = Выборка.Ссылка;
	Иначе
		СсылкаДокументаНаличнойОплатыПФРСтраховая = Документы.РасходИзКассы.ПустаяСсылка();
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура НайтиДокументыВзаиморасчетаСБюджетом()
	
	ДатыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СобытиеКалендаря,
		"ДатаДокументаОбработкиСобытия,ДатаОкончанияСобытия");
	
	ДокументВзаиморасчетовСБюджетомПФРСтраховая = РегламентированнаяОтчетностьУСН.ПолучитьДокументВзаиморасчетовСБюджетом(
		Объект.Организация,
		Справочники.ВидыНалогов.ПФРСвыше300тр,
		ДатаДокументаОбработкиСобытия,
		ДатаОкончанияДокументов,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокПлатежек(ОповещениеВыборПлатежек)
	
	Если Не ЗначениеЗаполнено(БанковскийСчетПоУмолчанию) Тогда
		оп = Новый ОписаниеОповещения("ОповещениеВыбораСчета", ЭтотОбъект, Новый Структура("ОповещениеВыборПлатежек", ОповещениеВыборПлатежек));
		РегламентированнаяОтчетностьУСНКлиент.ПолучитьБанковскийСчетДляУплатыНалога(оп, Объект.Организация);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеВыборПлатежек, Новый Структура ("БанковскийСчет", БанковскийСчетПоУмолчанию))
	
КонецПроцедуры


&НаКлиенте
Процедура ОповещениеВыбораСчета(БанковскийСчет, Параметры) Экспорт
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		СписокПлатежек = Новый СписокЗначений;
		БанковскийСчетПоУмолчанию = БанковскийСчет;
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеВыборПлатежек, Новый Структура ("СписокПлатежек, БанковскийСчет",СписокПлатежек, БанковскийСчетПоУмолчанию))
		
	Иначе
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеВыборПлатежек, Неопределено);
	КонецЕсли
КонецПроцедуры


&НаСервере
Функция ПолучитьСписокПлатежекНаСервере()
	
	// ПФРСтраховая
	Если ПФРСвыше300тр <> "0,00 р." Тогда
		СсылкаДокументаБезналичнойОплатыПФРСтраховая = РегламентированнаяОтчетностьУСН.СоздатьБезналичноеСписаниеПоВзаиморасчетамСБюджетом(
			ДокументВзаиморасчетовСБюджетомПФРСтраховая, БанковскийСчетПоУмолчанию, , ВсегоКУплатеВПФР);
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ОбновитьРасчет()

	РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР(КонецДня(ДатаДокументаОбработкиСобытия));
	РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРПриДоходахСвыше300тр(
		Объект.Организация, КонецДня(ДатаДокументаОбработкиСобытия), Объект.СобытиеКалендаря);
	ПолучитьДанныеОтчетности();

КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов управления
//
&НаКлиенте
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	
	Если ЗначениеЗаполнено(СсылкаДокументаНаличнойОплатыПФРСтраховая) Тогда
		Элементы.ГруппаСтрока10.Видимость = Ложь;
		Элементы.ГруппаСтрока11.Видимость = Ложь;
		Элементы.ГруппаСтрока12.Видимость = Истина;
	Иначе
		Элементы.ГруппаСтрока10.Видимость = Истина;
		Элементы.ГруппаСтрока11.Видимость = Истина;
		Элементы.ГруппаСтрока12.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьКвитанциюЗавершение() Экспорт
	
	СтруктураПечати = ВыгрузитьДокументВФайл(Новый Структура("НачислениеНалогов,Сумма", ДокументВзаиморасчетовСБюджетомПФРСтраховая, ВсегоКУплатеВПФР), "Квитанция");
	Если СтруктураПечати.АдресФайла = Неопределено Тогда
		
		Сообщить(Нстр("ru='Произошла ошибка при выгрузке документа '")+Объект);
		Возврат;
		
	КонецЕсли;
	
	ПолучитьФайл(СтруктураПечати.АдресФайла, Нстр("ru = 'Квитанция.pdf'"), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьПлатежноеПоручениеЗавершение() Экспорт
	
	ПолучитьСписокПлатежекНаСервере();
	СтруктураПечати = ВыгрузитьДокументВФайл(СсылкаДокументаБезналичнойОплатыПФРСтраховая, "ПлатежноеПоручение");
	Если СтруктураПечати.АдресФайла = Неопределено Тогда
		
		Сообщить(Нстр("ru='Произошла ошибка при выгрузке документа '")+Объект);
		Возврат;
		
	КонецЕсли;
	
	ПолучитьФайл(СтруктураПечати.АдресФайла, СтруктураПечати.НаименованиеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФайлКлиентБанка() Экспорт
	
	БанкСчетСтруктура = Новый Структура("БанковскийСчет", БанковскийСчетПоУмолчанию);
	
	ПолучитьСписокПлатежекНаСервере();
	СписокПлатежек = Новый СписокЗначений;
	Если ПФРСвыше300тр <> "0,00 р." Тогда
		СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРСтраховая);
	КонецЕсли;
	
	БанкСчетСтруктура.Вставить("СписокПлатежек", СписокПлатежек);
	
	ОткрытьФорму(
		"Обработка.КлиентБанк.Форма.СохранениеПлатежек",
		БанкСчетСтруктура,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьНаличиеГосОргана(ИмяПроцедурыПоЗавершениюСозданияГосОргана)
	КодГосОргана = "";
	Если ГосОрганСуществует(Объект.Организация, КодГосОргана) Тогда
		Возврат Истина;
	Иначе
		ДопПараметры = Новый Структура("ИмяПроцедурыПоЗавершениюСозданияГосОргана, КодГосОргана", ИмяПроцедурыПоЗавершениюСозданияГосОргана, КодГосОргана);
		ТекстВопроса = НСтр("ru='В справочнике «Контрагенты» не задано отделение ПФ РФ для уплаты взноса.
			|Создать его автоматически?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОСозданииГосОргана",
			ЭтаФорма, ДопПараметры);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Создать автоматически'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Создать вручную'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,,КодВозвратаДиалога.Да, НСтр("ru='Отсутствует налоговый орган'"));
		
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОтветеНаВопросОСозданииГосОргана(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаполнениеСведенийОНалоговойИнспекции(ДопПараметры);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ВидГосударственногоОргана", ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганПФР"));
		ПараметрыФормы.Вставить("КодГосударственногоОргана", ДопПараметры.КодГосОргана);
		ПараметрыФормы.Вставить("ИмяПроцедурыПоЗавершениюСозданияГосОргана",ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана);
		ПараметрыФормы.Вставить("ЗапретРедактированияКода", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеПлатежныхРеквизитовПФР", ЭтотОбъект, ПараметрыФормы);
		
		ОткрытьФорму("Справочник.Контрагенты.Форма.РеквизитыГосударственныхОрганов", ПараметрыФормы, ЭтотОбъект, ЭтотОбъект, , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеСведенийОНалоговойИнспекции(ДопПараметры)
	
	ОписаниеОшибки = "";
	ЗаполнитьСведенияОбОтделенииПФРПоКоду(ОписаниеОшибки, ДопПараметры.КодГосОргана);
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			
			ТекстВопроса = НСтр("ru='Для автоматического создания отделения ПФ РФ
				|в справочнике «Контрагенты» необходимо подключиться к Интернет-поддержке
				|пользователей. Подключиться сейчас?'");
				
			ПараметрыВопроса = Новый Структура("ВызовПослеПодключения,ИмяПроцедурыПоЗавершениюСозданияГосОргана", "ЗаполнитьСведенияОбОтделенииПФРПоКоду, КодГосОргана", ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана, ДопПараметры.КодГосОргана);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ПараметрыВопроса);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	Иначе
		Если ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
			РаспечататьКвитанциюЗавершение();
		ИначеЕсли ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьПлатежноеПоручениеЗавершение" Тогда
			РаспечататьПлатежноеПоручениеЗавершение();
		ИначеЕсли ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "ПолучитьФайлКлиентБанка" Тогда
			ПолучитьФайлКлиентБанка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если ДополнительныеПараметры.Свойство("ВызовПослеПодключения") Тогда
			
			Если ДополнительныеПараметры.ВызовПослеПодключения = "ЗаполнитьСведенияОбОтделенииПФРПоКоду" Тогда
				
				ЗаполнитьСведенияОбОтделенииПФРПоКоду(,ДополнительныеПараметры.КодГосОргана);
				
				Если ДополнительныеПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
					РаспечататьКвитанциюЗавершение();
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьСведенияОбОтделенииПФРПоКоду(ОписаниеОшибки = "", КодНалоговогоОрганаПолучателя)
	
	РеквизитыНалоговогоОргана = ДанныеГосударственныхОрганов.РеквизитыОтделенияПФРПоКоду(КодНалоговогоОрганаПолучателя);
	
	Если ЗначениеЗаполнено(РеквизитыНалоговогоОргана.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыНалоговогоОргана.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитыНалоговогоОргана.Ссылка) Тогда
		ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(РеквизитыНалоговогоОргана);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПлатежныхРеквизитовПФР(Ответ, ДопПараметры) Экспорт
	Если ТипЗнч(Ответ) = Тип("Структура") Тогда
		Если ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
			РаспечататьКвитанциюЗавершение();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ГосОрганСуществует(Организация, КодГосОргана)
	КодГосОргана = Организация.КодОрганаПФР;
	ГосОрган = ДанныеГосударственныхОрганов.ГосударственныйОрган(Перечисления.ВидыГосударственныхОрганов.ОрганПФР, КодГосОргана);
	
	Возврат ЗначениеЗаполнено(ГосОрган.Ссылка);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыгрузитьДокументВФайл(Объект, ВидФайла)
	
	ТабДок = Новый ТабличныйДокумент;
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект);
	
	Если ВидФайла = "Квитанция" Тогда
		Для Каждого Объект Из МассивОбъектов Цикл
			
			ТабДокОбъекта = Документы.НачислениеНалогов.СформироватьКвитанцию(Объект.НачислениеНалогов, Объект.Сумма);
			ТабДокОбъекта.Область().СоздатьФорматСтрок();
			Если ТабДок = Неопределено Тогда
				ТабДок = ТабДокОбъекта;
			Иначе
				ТабДок.Вывести(ТабДокОбъекта);
			КонецЕсли;
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЦикла;
	ИначеЕсли ВидФайла = "ПлатежноеПоручение" Тогда
		ОбъектыПечати = Новый СписокЗначений;
		ТабДок = Документы.ПлатежноеПоручение.ПечатнаяФорма(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	СтруктураПечати = Новый Структура ("АдресФайла, НаименованиеФайла");
	
	Если ТабДок = Неопределено Тогда
		Возврат СтруктураПечати;
	КонецЕсли;
	
	Каталог = КаталогВременныхФайлов()+РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()+"\";
	
	ПроверкаКаталога = Новый Файл(Каталог);
	Если НЕ ПроверкаКаталога.Существует() Тогда
		СоздатьКаталог(Каталог);
	КонецЕсли;
	РасширениеФайла = ".pdf" ;
	НаименованиеФайла = Строка(Объект);
	НаименованиеФайла = ?(СтрДлина(НаименованиеФайла)+СтрДлина(РасширениеФайла)>64, Лев(НаименованиеФайла,64 - СтрДлина(РасширениеФайла)),НаименованиеФайла);
	НаименованиеФайла = СтрЗаменить(НаименованиеФайла, ":","_");
	
	ПолноеИмяФайла = Каталог + НаименованиеФайла + РасширениеФайла;
	ПолноеИмяФайла = СтрЗаменить(ПолноеИмяФайла, """","");
	
	Попытка
		ТабДок.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);
		
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка сохранения файла на сервере'"),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru= 'При сохранении файла на сервере в области данных %1 произошла ошибка:
						|%2'"),
				РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(),
				ОписаниеОшибки()),
			РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
		
		Возврат СтруктураПечати;
		
	КонецПопытки;
	ДанныеФайла = Новый ДвоичныеДанные(ПолноеИмяФайла);
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла, Новый УникальныйИдентификатор);
	УдалитьФайлы(ПолноеИмяФайла);
	СтруктураПечати.АдресФайла = АдресФайла;
	СтруктураПечати.НаименованиеФайла = НаименованиеФайла+РасширениеФайла;
	
	Возврат СтруктураПечати;
	
КонецФункции

#КонецОбласти
