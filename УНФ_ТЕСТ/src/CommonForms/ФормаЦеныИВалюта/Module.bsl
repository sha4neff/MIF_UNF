
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаУчета = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту();
	ЗаполнитьТаблицуКурсовВалют();
	ПолучитьЗначенияПараметровФормы();
	
	Если ДоговорЕстьРеквизит Тогда	
		НовыйМассив = Новый Массив();
		Если РасчетыВУЕ И ВалютаУчета <> ВалютаРасчетов Тогда
			НовыйМассив.Добавить(ВалютаУчета);
		КонецЕсли;
		НовыйМассив.Добавить(ВалютаРасчетов);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(НовыйМассив));
		НовыйМассив2 = Новый Массив();
		НовыйМассив2.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив2);
		Элементы.Валюта.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
	
	Параметры.Свойство("ТекстПредупреждения", ТекстПредупреждения);
	Если ПустаяСтрока(ТекстПредупреждения) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПредупреждение", "Видимость", Ложь);
	КонецЕсли;
	
	Элементы.Предупреждение.Заголовок = ТекстПредупреждения;
	Элементы.ГруппаКурсКратностьПересчетаЦен.Видимость = ПересчитатьЦены;
	
	// ДисконтныеКарты
	Параметры.Свойство("ДатаДокумента", ДатаДокумента);
	НастроитьНадписьПоДисконтнойКарте();
	
	УправлениеНебольшойФирмойСервер.НастроитьВспомогательнуюФормуМобильныйКлиент(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсРасчетов, ВалютаРасчетов, ДатаДокумента);
	Если ВалютаДокумента = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
		РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен, ВалютаДокументаПриОткрытии, ДатаДокумента);
	Иначе
		РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен, ВалютаРасчетов, ДатаДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидЦен) Тогда
		
		Если ВидЦенПриОткрытии <> ВидЦен Тогда
			
			ПерезаполнитьЦены = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦенКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидЦенКонтрагента) Тогда
		
		Если ВидЦенКонтрагентаПриОткрытии <> ВидЦенКонтрагента Тогда
			
			ПерезаполнитьЦены = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСкидкиПриИзменении(Элемент)
	
	Если ВидСкидкиПриОткрытии <> ВидСкидки Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
	РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен, ВалютаДокумента, ДатаДокумента);
	
	Если ЗначениеЗаполнено(ВалютаДокумента)
		
		И ВалютаДокументаПриОткрытии <> ВалютаДокумента Тогда
		ПересчитатьЦены = Истина;
		ПересчитатьЦеныПриИзменении(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура КратностьРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьЦеныПриИзменении(Элемент)
	
	Если ВидЦенЕстьРеквизит Тогда
		
		Если ПерезаполнитьЦены Тогда
			Если ВидСкидки.Пустая() И Не ДисконтнаяКарта.Пустая() Тогда // ДисконтныеКарты
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			Иначе
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		Иначе	
			Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;
		
	ИначеЕсли ВидЦенКонтрагентаЕстьРеквизит Тогда
		
		Если ПерезаполнитьЦены ИЛИ РегистрироватьЦеныПоставщика Тогда
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
		Иначе	
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьЦеныПоставщикаПриИзменении(Элемент)
	
	Если РегистрироватьЦеныПоставщика ИЛИ ПерезаполнитьЦены Тогда
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
	Иначе	
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
		ОтключитьОтметкуНезаполненного();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДисконтнаяКартаПриИзменении(Элемент)
	
	Если ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта Тогда
		
		ПерезаполнитьЦены = Истина;
		
	КонецЕсли;
	
	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
	ПерезаполнитьЦеныПриИзменении(Элементы.ПерезаполнитьЦены);
	
КонецПроцедуры

&НаКлиенте
Процедура ДисконтнаяКартаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораДисконтнойКартыЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ДисконтныеКарты.ФормаВыбора", Новый Структура("Контрагент, ОтборПоКонтрагенту", Контрагент, Истина), ЭтаФорма.ДисконтнаяКарта, ЭтаФорма.УникальныйИдентификатор, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсРасчетовОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, "Укажите дату курса валюты", ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсПересчетаЦенОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсПересчетаЦенОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, "Укажите дату курса валюты", ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦеныПриИзменении(Элемент)
	
	Элементы.ГруппаКурсКратностьПересчетаЦен.Видимость = ПересчитатьЦены;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ЕстьОшибкиВЗаполненииПолей() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Результат.Вставить("БылиВнесеныИзменения", БылиВнесеныИзменения());
	
	Результат.Вставить("ВидЦен", ВидЦен);
	Результат.Вставить("ВидЦенКонтрагента", ВидЦенКонтрагента);
	Результат.Вставить("РегистрироватьЦеныПоставщика", РегистрироватьЦеныПоставщика);
	Результат.Вставить("ВидСкидки", ВидСкидки);
	
	Результат.Вставить("ВалютаДокумента", ВалютаДокумента);
	Результат.Вставить("НалогообложениеНДС", НалогообложениеНДС);
	Результат.Вставить("СпециальныйНалоговыйРежим", СпециальныйНалоговыйРежим);
	Результат.Вставить("СуммаВключаетНДС", СуммаВключаетНДС);
	Результат.Вставить("НДСВключатьВСтоимость", НДСВключатьВСтоимость);
	
	Результат.Вставить("ВалютаРасчетов", ВалютаРасчетов);
	Результат.Вставить("КурсРасчетов", КурсРасчетов);
	Результат.Вставить("КратностьРасчетов", КратностьРасчетов);
	
	Результат.Вставить("ПредВалютаДокумента", ВалютаДокументаПриОткрытии);
	Результат.Вставить("ПредНалогообложениеНДС", НалогообложениеНДСПриОткрытии);
	Результат.Вставить("ПредСпециальныйНалоговыйРежим", СпециальныйНалоговыйРежимПриОткрытии);
	Результат.Вставить("ПредСуммаВключаетНДС", СуммаВключаетНДСПриОткрытии);
	
	Результат.Вставить("ПерезаполнитьЦены", ПерезаполнитьЦены);
	Результат.Вставить("ПересчитатьЦены", ПересчитатьЦены);
	
	Результат.Вставить("ИмяФормы", "ОбщаяФорма.ФормаВалюта");
	
	Результат.Вставить("КурсПересчетаЦен", Новый Структура);
	Результат.КурсПересчетаЦен.Вставить("Курс", КурсПересчетаЦен);
	Результат.КурсПересчетаЦен.Вставить("Кратность", КратностьПересчетаЦен);
	
	// ДисконтныеКарты
	Результат.Вставить("ПерезаполнитьСкидки", ПерезаполнитьЦены ИЛИ СуммаВключаетНДС <> СуммаВключаетНДСПриОткрытии);
	
	Результат.Вставить("ДисконтнаяКарта", ДисконтнаяКарта);
	Результат.Вставить("ИзмененаДисконтнаяКарта", ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта);
	Результат.Вставить("ПроцентСкидкиПоДисконтнойКарте", ПроцентСкидкиПоДисконтнойКарте);
	Результат.Вставить("Контрагент", ПолучитьВладельцаКарты(ДисконтнаяКарта));
	// Конец ДисконтныеКарты
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьЗначенияПараметровФормы()
	
	КлючПоложения = "";
	
	// Вид цены.
	Если Параметры.Свойство("ВидЦен") Тогда
		
		// Вид цены.
		ВидЦен = Параметры.ВидЦен;
		ВидЦенПриОткрытии = Параметры.ВидЦен;
		ВидЦенЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВидЦен";
		
	Иначе
		
		// Доступность вида цены.
		Элементы.ВидЦен.Видимость = Ложь;
		ВидЦенЕстьРеквизит = Ложь;
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступностьВалютыДокумента") Тогда
		
		Элементы.Валюта.Доступность = Параметры.ДоступностьВалютыДокумента;
		Элементы.ПересчитатьЦены.Видимость = Параметры.ДоступностьВалютыДокумента;
		
	КонецЕсли;
	
	// Вид цены контрагента.
	Если Параметры.Свойство("ВидЦенКонтрагента") Тогда
		
		// Вид цены.
		ВидЦенКонтрагента = Параметры.ВидЦенКонтрагента;
		ВидЦенКонтрагентаПриОткрытии = Параметры.ВидЦенКонтрагента;
		Контрагент = Параметры.Контрагент;
		ВидЦенКонтрагентаЕстьРеквизит = Истина;
		
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Контрагент);
		МассивЗначений = Новый ФиксированныйМассив(МассивЗначений);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", МассивЗначений);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.ВидЦенКонтрагента.ПараметрыВыбора = НовыеПараметры;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПерезаполнитьЦены", "Видимость", ПолучитьФункциональнуюОпцию("УчетЦенКонтрагентов"));
		КлючПоложения = КлючПоложения + "ВидЦенКонтрагента";
		
	Иначе
		
		// Доступность вида цены контрагента.
		Элементы.ВидЦенКонтрагента.Видимость = Ложь;
		ВидЦенКонтрагентаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// РегистрироватьЦеныПоставщика.
	Если Параметры.Свойство("РегистрироватьЦеныПоставщика") Тогда
		
		РегистрироватьЦеныПоставщика = Параметры.РегистрироватьЦеныПоставщика;
		РегистрироватьЦеныПоставщикаПриОткрытии = Параметры.РегистрироватьЦеныПоставщика;
		РегистрироватьЦеныПоставщикаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "РегистрироватьЦеныПоставщика";
		
	Иначе
		
		// Доступность.
		Элементы.РегистрироватьЦеныПоставщика.Видимость = Ложь;
		РегистрироватьЦеныПоставщикаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Флаг - перезаполнить цены.
	Если НЕ (ВидЦенЕстьРеквизит ИЛИ ВидЦенКонтрагентаЕстьРеквизит) Тогда
		
		Элементы.ПерезаполнитьЦены.Видимость = Ложь;
		КлючПоложения = КлючПоложения + "НеПерезаполнятьЦены";
		
	КонецЕсли; 
	
	// Скидки.
	Если Параметры.Свойство("ВидСкидки") Тогда
		
		ВидСкидки = Параметры.ВидСкидки;
		ВидСкидкиПриОткрытии = Параметры.ВидСкидки;
		ВидСкидкиЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВидСкидки";
		
	Иначе
		
		Элементы.ВидСкидки.Видимость = Ложь;
		ВидСкидкиЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Дисконтные карты.
	Если Параметры.Свойство("ДисконтнаяКарта") Тогда
		
		ДисконтнаяКарта = Параметры.ДисконтнаяКарта;
		ДисконтнаяКартаПриОткрытии = Параметры.ДисконтнаяКарта;
		ДисконтнаяКартаЕстьРеквизит = Истина;
		Если Параметры.Свойство("Контрагент") Тогда
			Контрагент = Параметры.Контрагент;
		КонецЕсли;
		Элементы.ДисконтнаяКарта.Видимость = Истина;
		ДисконтнаяКартаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ДисконтнаяКарта";
		
	Иначе
		
		Элементы.ДисконтнаяКарта.Видимость = Ложь;
		ДисконтнаяКартаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Валюта документа.
	Если Параметры.Свойство("ВалютаДокумента") Тогда
		
		ВалютаДокумента = Параметры.ВалютаДокумента;
		ВалютаДокументаПриОткрытии = Параметры.ВалютаДокумента;
		ВалютаДокументаЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "ВалютаДокумента";
		
	Иначе
		
		Элементы.ВалютаДокумента.Видимость = Ложь;
		Элементы.КурсПересчетаЦен.Видимость = Ложь;
		Элементы.КратностьПересчетаЦен.Видимость = Ложь;
		Элементы.ПересчитатьЦены.Видимость = Ложь;
		ВалютаДокументаЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ВалютаПередИзменением") Тогда
		ВалютаДокументаПриОткрытии = Параметры.ВалютаПередИзменением;
	КонецЕсли;
	
	// Налогообложение НДС.
	Если Параметры.Свойство("НалогообложениеНДС") Тогда
		
		НалогообложениеНДС = Параметры.НалогообложениеНДС;
		НалогообложениеНДСПриОткрытии = Параметры.НалогообложениеНДС;
		НалогообложениеНДСЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "НалогообложениеНДС";
		
	Иначе
		
		Элементы.НалогообложениеНДС.Видимость = Ложь;
		НалогообложениеНДСЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Специальный налоговый режим.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование")
		И Параметры.Свойство("СпециальныйНалоговыйРежим") Тогда
		
		СпециальныйНалоговыйРежим = Параметры.СпециальныйНалоговыйРежим;
		СпециальныйНалоговыйРежимПриОткрытии = Параметры.СпециальныйНалоговыйРежим;
		СпециальныйНалоговыйРежимЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "СпециальныйНалоговыйРежим";
		
	Иначе
		
		Элементы.СпециальныйНалоговыйРежим.Видимость = Ложь;
		СпециальныйНалоговыйРежимЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	// Сумма включает НДС.
	Если Параметры.Свойство("СуммаВключаетНДС") Тогда
		
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСПриОткрытии = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "СуммаВключаетНДС";
		
	Иначе
		
		Элементы.СуммаВключаетНДС.Видимость = Ложь;
		СуммаВключаетНДСЕстьРеквизит = Ложь;
		
	КонецЕсли;	
	
	// НДС включать в стоимость.
	Если Параметры.Свойство("НДСВключатьВСтоимость") Тогда
		
		НДСВключатьВСтоимость = Параметры.НДСВключатьВСтоимость;
		НДСВключатьВСтоимостьПриОткрытии = Параметры.НДСВключатьВСтоимость;
		НДСВключатьВСтоимостьЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "НДСВключатьВСтоимость";
		
	Иначе
		
		Элементы.НДСВключатьВСтоимость.Видимость = Ложь;
		НДСВключатьВСтоимостьЕстьРеквизит = Ложь;
		
	КонецЕсли;
		
	// Валюта расчетов.
	Если Параметры.Свойство("Договор") Тогда
		
		ВалютаРасчетов	  = Параметры.Договор.ВалютаРасчетов;
		РасчетыВУЕ		  = Параметры.Договор.РасчетыВУсловныхЕдиницах;
		КурсРасчетов 	  = Параметры.Курс;
		КратностьРасчетов = Параметры.Кратность;
		
		КурсРасчетовПриОткрытии 	 = Параметры.Курс;
		КратностьРасчетовПриОткрытии = Параметры.Кратность;
		
		ДоговорЕстьРеквизит = Истина;
		
		КлючПоложения = КлючПоложения + "Договор";
		
		Если Параметры.Свойство("ЭтоСчетФактура") Тогда
			
			Элементы.ВалютаРасчетов.Видимость = Ложь;
			Элементы.КурсРасчетов.Видимость = Ложь;
			Элементы.КратностьРасчетов.Видимость = Ложь;
			
			КлючПоложения = КлючПоложения + "ЭтоСчетФактура";
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ВалютаРасчетов.Видимость = Ложь;
		Элементы.КурсРасчетов.Видимость = Ложь;
		Элементы.КратностьРасчетов.Видимость = Ложь;
		
		ДоговорЕстьРеквизит = Ложь;
		
	КонецЕсли;
	
	ПерезаполнитьЦены = Параметры.ПерезаполнитьЦены;
	ПересчитатьЦены   = Параметры.ПересчитатьЦены;
		
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
		
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаРасчетов));
		Если ВалютаДокумента = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
			МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокументаПриОткрытии));
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				КурсПересчетаЦен = МассивКурсКратность[0].Курс;
				КратностьПересчетаЦен = МассивКурсКратность[0].Кратность;
			Иначе
				КурсПересчетаЦен = Курс;
				КратностьПересчетаЦен = Кратность;
			КонецЕсли;
		Иначе
			КурсПересчетаЦен = Курс;
			КратностьПересчетаЦен = Кратность;
		КонецЕсли;
		
	КонецЕсли;
	
	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(КлючПоложения);
	ЭтотОбъект.КлючСохраненияПоложенияОкна = "ЦеныИВалюта" + СтрЗаменить(Хеш.ХешСумма, " ", "");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКурсовВалют()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", Параметры.ДатаДокумента);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	КурсыВалют.Загрузить(ТаблицаРезультатаЗапроса);
	
КонецПроцедуры // ЗаполнитьТаблицуКурсовВалют()

&НаКлиенте
Функция ЕстьОшибкиВЗаполненииПолей()
	
	Результат = Ложь;
	
	// Вид цен контрагента.
	Если (ПерезаполнитьЦены ИЛИ РегистрироватьЦеныПоставщика) И ВидЦенКонтрагентаЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВидЦенКонтрагента) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не выбран вид цен контрагента для заполнения!'");
			Сообщение.Поле = "ВидЦенКонтрагента";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Валюта документа.
	Если ВалютаДокументаЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена валюта документа!'");
			Сообщение.Поле = "ВалютаДокумента";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Налогообложение НДС.
	Если НалогообложениеНДСЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(НалогообложениеНДС) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнено налогообложение!'");
			Сообщение.Поле = "НалогообложениеНДС";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Специальный налоговый режим.
	Если СпециальныйНалоговыйРежимЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(СпециальныйНалоговыйРежим) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнен специальный налоговый режим!'");
			Сообщение.Поле = "СпециальныйНалоговыйРежим";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Расчеты.
	Если ДоговорЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(КурсРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов!'");
			Сообщение.Поле = "КурсРасчетов";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КратностьРасчетов) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Обнаружена нулевая кратность курса валюты расчетов!'");
			Сообщение.Поле = "КратностьРасчетов";
			Сообщение.Сообщить();
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Вид цен.
	Если ПерезаполнитьЦены И ВидЦенЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
			Если ВидСкидки.Пустая() И Не ДисконтнаяКарта.Пустая() Тогда // ДисконтныеКарты
				// Можно в документе пересчитать скидки по дисконтной карте.
			Иначе
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = НСтр("ru = 'Не выбран вид цены для заполнения!'");
				Сообщение.Поле = "ВидЦен";
				Сообщение.Сообщить();
			КонецЕсли;
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция БылиВнесеныИзменения()
	
	ИзмененияВидЦен 				= ?(ВидЦенЕстьРеквизит, ВидЦенПриОткрытии <> ВидЦен, Ложь);
	ИзмененияВидЦенКонтрагента 		= ?(ВидЦенКонтрагентаЕстьРеквизит, ВидЦенКонтрагентаПриОткрытии <> ВидЦенКонтрагента, Ложь);
	ИзмененияРегистрироватьЦеныПоставщика = ?(РегистрироватьЦеныПоставщикаЕстьРеквизит, РегистрироватьЦеныПоставщикаПриОткрытии <> РегистрироватьЦеныПоставщика, Ложь);
	ИзмененияВидСкидки 				= ?(ВидСкидкиЕстьРеквизит, ВидСкидкиПриОткрытии <> ВидСкидки, Ложь);
	ИзмененияВалютаДокумента 		= ?(ВалютаДокументаЕстьРеквизит, ВалютаДокументаПриОткрытии <> ВалютаДокумента, Ложь);
	ИзмененияНалогообложениеНДС 	= ?(НалогообложениеНДСЕстьРеквизит, НалогообложениеНДСПриОткрытии <> НалогообложениеНДС, Ложь);
	ИзмененияСпециальныйНалоговыйРежим = ?(СпециальныйНалоговыйРежимЕстьРеквизит, СпециальныйНалоговыйРежимПриОткрытии <> СпециальныйНалоговыйРежим, Ложь);
	ИзмененияСуммаВключаетНДС 		= ?(СуммаВключаетНДСЕстьРеквизит, СуммаВключаетНДСПриОткрытии <> СуммаВключаетНДС, Ложь);
	ИзмененияНДСВключатьВСтоимость 	= ?(НДСВключатьВСтоимостьЕстьРеквизит, НДСВключатьВСтоимостьПриОткрытии <> НДСВключатьВСтоимость, Ложь);
	ИзмененияКурсРасчетов 			= ?(ДоговорЕстьРеквизит, КурсРасчетовПриОткрытии <> КурсРасчетов, Ложь);
	ИзмененияКратностьРасчетов 		= ?(ДоговорЕстьРеквизит, КратностьРасчетовПриОткрытии <> КратностьРасчетов, Ложь);
	ИзмененияДисконтнаяКарта		= ?(ДисконтнаяКартаЕстьРеквизит, ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта, Ложь); // ДисконтныеКарты
	
	Если ПерезаполнитьЦены
		ИЛИ ПересчитатьЦены
		ИЛИ ИзмененияВалютаДокумента
		ИЛИ ИзмененияНалогообложениеНДС
		ИЛИ ИзмененияСпециальныйНалоговыйРежим
		ИЛИ ИзмененияСуммаВключаетНДС
		ИЛИ ИзмененияНДСВключатьВСтоимость
		ИЛИ ИзмененияКурсРасчетов
		ИЛИ ИзмененияКратностьРасчетов
		ИЛИ ИзмененияВидЦен
		ИЛИ ИзмененияВидЦенКонтрагента
		ИЛИ ИзмененияРегистрироватьЦеныПоставщика
		ИЛИ ИзмененияДисконтнаяКарта // ДисконтныеКарты
		ИЛИ ИзмененияВидСкидки Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьКурсКратностьВалютыДокумента()
	
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
		Если ВалютаДокумента = ВалютаРасчетов
		   И КурсРасчетов <> 0
		   И КратностьРасчетов <> 0 Тогда
			Курс = КурсРасчетов;
			Кратность = КратностьРасчетов;
		Иначе
			Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
				Курс = МассивКурсКратность[0].Курс;
				Кратность = МассивКурсКратность[0].Кратность;
			Иначе
				Курс = 0;
				Кратность = 0;
			КонецЕсли;
		КонецЕсли;
		Если ВалютаДокумента <> УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
			КурсПересчетаЦен = Курс;
			КратностьПересчетаЦен = Кратность;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьКурсКратностьВалютыДокумента()

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсПересчетаЦенОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсПересчетаЦенОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаКурса);
	ЭтаФорма.КурсРасчетов = КурсНаДату.Курс;
	ЭтаФорма.КратностьРасчетов = КурсНаДату.Кратность;
	
КонецПроцедуры

&НаСервере
Процедура КурсПересчетаЦенОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаКурса);
	ЭтаФорма.КурсПересчетаЦен = КурсНаДату.Курс;
	ЭтаФорма.КратностьПересчетаЦен = КурсНаДату.Кратность;
	
КонецПроцедуры


#КонецОбласти

#Область ДисконтныеКарты

&НаСервереБезКонтекста
Функция ПолучитьВладельцаКарты(ДисконтнаяКарта)

	Возврат ДисконтнаяКарта.ВладелецКарты;

КонецФункции // ПолучитьВладельцаКарты()

// Процедура вызывается после выбора дисконтной карты из формы выбора справочника ДисконтныеКарты.
//
&НаКлиенте
Процедура ОткрытьФормуВыбораДисконтнойКартыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда 
		ДисконтнаяКарта = РезультатЗакрытия;
	
		Если ДисконтнаяКартаПриОткрытии <> ДисконтнаяКарта Тогда
			
			ПерезаполнитьЦены = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
КонецПроцедуры

// Процедура заполняет подсказку дисконтной карты информацией о скидке по дисконтной карте.
//
&НаСервере
Процедура НастроитьНадписьПоДисконтнойКарте()
	
	Если Не ДисконтнаяКарта.Пустая() Тогда
		Если Не Контрагент.Пустая() И ДисконтнаяКарта.Владелец.ЭтоИменнаяКарта И ДисконтнаяКарта.ВладелецКарты <> Контрагент Тогда
			
			ДисконтнаяКарта = Справочники.ДисконтныеКарты.ПустаяСсылка();
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Владелец дисконтной карты не совпадает с контрагентом в документе.";
			Сообщение.Поле = "ДисконтнаяКарта";
			Сообщение.Сообщить();
			
		КонецЕсли;
	КонецЕсли;
	
	Если ДисконтнаяКарта.Пустая() Или Не ДисконтнаяКарта.Владелец.СтарыйМеханизмСкидок Тогда
		ПроцентСкидкиПоДисконтнойКарте = 0;
		Элементы.ДисконтнаяКарта.Подсказка = "";
	Иначе
		ПроцентСкидкиПоДисконтнойКарте = УправлениеНебольшойФирмойСервер.ВычислитьПроцентСкидкиПоДисконтнойКарте(ДатаДокумента, ДисконтнаяКарта);		
		Элементы.ДисконтнаяКарта.Подсказка = "Скидка по карте составляет "+ПроцентСкидкиПоДисконтнойКарте+"%";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти