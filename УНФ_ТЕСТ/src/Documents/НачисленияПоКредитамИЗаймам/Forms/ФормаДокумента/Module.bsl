#Область ПроцедурыИФункцииОбщегоНазначения

// Функция помещает табличную часть Начисления во временное хранилище
// и возвращает адрес
//
&НаСервере
Функция ПоместитьНачисленияВХранилище()

	АдресВХранилище = ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(), УникальныйИдентификатор);
	Возврат АдресВХранилище;

КонецФункции

// Процедура получает табличную часть Начисления из временного хранилища.
//
&НаСервере
Процедура ПолучитьНачисленияИзХранилища(АдресНачисленийВХранилище)

	Объект.Начисления.Загрузить(ПолучитьИзВременногоХранилища(АдресНачисленийВХранилище));

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидОперацииПриИзмененииНаСервере();
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	ВидОперацииНачисленияПоКредитам = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// МобильныйКлиент
	УправлениеНебольшойФирмойСервер.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	// Конец МобильныйКлиент
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидОперации = Объект.ВидОперации;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("АдресНачисленийВХранилище") Тогда
			ПолучитьНачисленияИзХранилища(ВыбранноеЗначение.АдресНачисленийВХранилище);
			Модифицированность = Истина;
			
			Если Объект.Начисления.Количество() = 0 Тогда
				СтрокаДляВидаОперации = ?(Объект.ВидОперации = ВидОперацииНачисленияПоКредитам, "кредитам", "займам");
				ПоказатьПредупреждение(Неопределено, "За указанный период выполнять начисления по "+СтрокаДляВидаОперации+" не требуется");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура обработчик события ОбработкаПроверкиЗаполненияНаСервере.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

// Процедура обработчик события ПередЗаписьюНаСервере.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыДействияКоманд

// Процедура - обработчик команды ЗаполнитьНачисления.
//
&НаКлиенте
Процедура ЗаполнитьНачисления(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана операция!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана организация!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указано начало периода начислений!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указан конец периода начислений!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.ДатаОкончания > Объект.ДатаНачала Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Указан неверный период. Дата начала > Даты окончания!'"));
		Возврат;
	КонецЕсли;
	
	АдресНачисленийВХранилище = ПоместитьНачисленияВХранилище();
	ПараметрыОтбора = Новый Структура("
		|АдресНачисленийВХранилище,
		|Организация,
		|Регистратор,
		|ВидОперации,
		|ДатаНачала,
		|ДатаОкончания",
		АдресНачисленийВХранилище,
		Объект.Организация,
		Объект.Ссылка,
		Объект.ВидОперации,
		Объект.ДатаНачала,
		Объект.ДатаОкончания);
	
	ОткрытьФорму("Документ.НачисленияПоКредитамИЗаймам.Форма.ФормаЗаполнения", 
						ПараметрыОтбора,
						ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ПредопределенноеЗначение("Справочник.НаборыДополнительныхРеквизитовИСведений.Документ_НачисленияПоКредитамИЗаймам"));
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийРеквизитовШапки

// Процедура - обработчик события ПриИзменении поля ввода ВидОперации.
//
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если ВидОперации <> Объект.ВидОперации Тогда
		ВидОперации = Объект.ВидОперации;
		
		Объект.Начисления.Очистить();
		
		ВидОперацииПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВидОперации. Серверная часть.
//
&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	ВидОперации = Объект.ВидОперации;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам") Тогда
		Элементы.НачисленияКонтрагент.Видимость = Истина;
		Элементы.НачисленияСотрудник.Видимость = Ложь;
	Иначе
		Элементы.НачисленияКонтрагент.Видимость = Ложь;
		Элементы.НачисленияСотрудник.Видимость = Истина;
	КонецЕсли;
	
	НовыйМассив = Новый Массив();
	Если Объект.ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный);
	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику);
	КонецЕсли;
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.НачисленияДоговорКредитаИЗайма.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаНачала.
//
&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийРеквизитовТабличнойЧасти

// Процедура - обработчик события ПриИзменении реквизита ДоговорКредитаИЗайма табличной части Начисления.
//
&НаКлиенте
Процедура НачисленияДоговорКредитаИЗаймаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураРеквизитов = НачисленияДоговорКредитаИЗаймаПриИзмененииНаСервере(ТекущиеДанные.ДоговорКредитаЗайма, Объект.ВидОперации);
		ТекущиеДанные.ВалютаРасчетов = СтруктураРеквизитов.ВалютаРасчетов;
		Если СтруктураРеквизитов.Свойство("Контрагент") И ТекущиеДанные.Контрагент.Пустая() Тогда
			ТекущиеДанные.Контрагент = СтруктураРеквизитов.Контрагент;
		КонецЕсли;
		Если СтруктураРеквизитов.Свойство("Сотрудник") И ТекущиеДанные.Сотрудник.Пустая() Тогда
			ТекущиеДанные.Сотрудник = СтруктураРеквизитов.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НачисленияДоговорКредитаИЗаймаПриИзмененииНаСервере(ДоговорКредитаЗайма, ВидОперации)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ВалютаРасчетов", ДоговорКредитаЗайма.ВалютаРасчетов);
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам И
		ДоговорКредитаЗайма.ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный Тогда
		
		СтруктураРеквизитов.Вставить("Контрагент", ДоговорКредитаЗайма.Контрагент);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоЗаймамСотрудникам И
		ДоговорКредитаЗайма.ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику Тогда
		
		СтруктураРеквизитов.Вставить("Сотрудник", ДоговорКредитаЗайма.Сотрудник);
		
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
