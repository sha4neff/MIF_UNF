
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("АдресСхемы") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ДанныеРасшифровки") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Расшифровка") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.ДанныеРасшифровки);
	
	ДанныеРасшифровки.Настройки.ДополнительныеСвойства.Вставить("АдресСхемы", Параметры.АдресСхемы);
	
	ПараметрыРасшифровки = Новый Структура;
	
	Для Каждого ТекЭлемент Из ДанныеРасшифровки.Элементы.Получить(Параметры.Расшифровка).ПолучитьПоля() Цикл
		ПараметрыРасшифровки.Вставить(ТекЭлемент.Поле, ТекЭлемент.Значение);
	КонецЦикла;
	
	
	Если ПараметрыРасшифровки.Свойство("ЭтоПотери") Тогда
		ДокументРезультат = РезультатОбработкиРасшифровкиНаСервере(ДанныеРасшифровки.Настройки, ПараметрыРасшифровки);
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРасшифровки.Свойство("ЭтоПоказательРасходов") Тогда
		
		ЗаголовокИсточники = ПараметрыРасшифровки.Источник;
		Если НЕ ЗначениеЗаполнено(ЗаголовокИсточники) Тогда
			ЗаголовокИсточники = ?(ПараметрыРасшифровки.ЭтоИтоги, НСтр("ru = 'Итого'"), НСтр("ru = '<Нет группы>'"));
		КонецЕсли;
		
		Заголовок = СтрШаблон(НСтр("ru = 'Источник привлечения: %1'"), ЗаголовокИсточники); 
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Лид" Тогда
		Заголовок = ПредставлениеРасшифровкиЛиды(ПараметрыРасшифровки);
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Покупатель" Тогда
		Заголовок = ПредставлениеРасшифровкиПокупатели(ПараметрыРасшифровки);
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Заказ" Тогда
		Заголовок = ПредставлениеРасшифровки(ПараметрыРасшифровки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатОбработкиРасшифровкиНаСервере(НастройкиКД, ПараметрыРасшифровки)
	
	ВариантВоронки = Отчеты.ВоронкаПродаж.ВариантВоронки(НастройкиКД);
	ВидВоронки = Отчеты.ВоронкаПродаж.ВидВоронки(НастройкиКД);
	
	Если ПараметрыРасшифровки.Свойство("ЭтоПоказательРасходов") Тогда
		
		Если ПараметрыРасшифровки.ЭтоПоказательРасходов Тогда
			Возврат РезультатОбработкаРасшифровкиРасходы(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки);
		Иначе
			Возврат РезультатОбработкаРасшифровкиИсточник(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Заказ" Тогда
		
		Возврат РезультатОбработкаРасшифровкиПоЗаказу(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки);
		
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Лид" Тогда
		
		Возврат РезультатОбработкаРасшифровкиПоЛиду(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
		
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ОбъектВоронки = "Покупатель" Тогда
		
		Возврат РезультатОбработкаРасшифровкиПоПокупателю(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьОбластьРасшифровки(МакетРасшифровки, Выборка, Потери, Состояние)
	
	Если Потери ИЛИ Состояние = "ОтменилиЗаказ" Тогда
		Возврат МакетРасшифровки.ПолучитьОбласть("Строка");
	КонецЕсли;
	
	Если Выборка.ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Отменен 
		ИЛИ Выборка.ВариантЗавершения = Перечисления.ВариантЗавершенияРаботыСЛидом.НекачественныйЛид Тогда
		Возврат МакетРасшифровки.ПолучитьОбласть("СтрокаОтмена");
	КонецЕсли;
	
	Возврат МакетРасшифровки.ПолучитьОбласть("Строка");
	
КонецФункции

&НаСервере
Функция ПредставлениеРасшифровки(ПараметрыРасшифровки)
	
	Возврат СтрШаблон(НСтр("ru = '%1: %2, уровень воронки: %3'"),
	?(ПараметрыРасшифровки.ЭтоПотери, НСтр("ru = 'Потери'"), НСтр("ru = 'Заказы'")),
	ПараметрыРасшифровки.ПолеГруппировки,
	ПараметрыРасшифровки.Состояние);
	
КонецФункции

&НаСервере
Функция ПредставлениеРасшифровкиПокупатели(ПараметрыРасшифровки)
	
	УровеньВоронки = "";
	
	Если ПараметрыРасшифровки.ВидОбъекта = "Лид" Тогда
		Заголовок = НСтр("ru = 'Лиды'");
	ИначеЕсли ПараметрыРасшифровки.ВидОбъекта = "Покупатель" Тогда
		Заголовок = НСтр("ru = 'Покупатели'");
	КонецЕсли;
	
	Если ПараметрыРасшифровки.Состояние = "СовершенаПродажа" Тогда
		УровеньВоронки = НСтр("ru = 'Совершена продажа'");
	ИначеЕсли ПараметрыРасшифровки.Состояние = "ВедетсяРабота" Тогда
		УровеньВоронки = НСтр("ru = 'Ведется работа по заказам'");
	ИначеЕсли ПараметрыРасшифровки.Состояние = "ОтменилиЗаказ" Тогда
		УровеньВоронки = НСтр("ru = 'Отменили заказ'");
	ИначеЕсли ПараметрыРасшифровки.Состояние = "НетПродаж" Тогда
		УровеньВоронки = НСтр("ru = 'Нет продаж и заказов'");
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыРасшифровки.ПолеГруппировки) = Тип("Булево") Тогда
		Возврат СтрШаблон(НСтр("ru = '%1: %2, уровень воронки: %3'"), Заголовок,
		НСтр("ru = 'Все'"), УровеньВоронки);
	Иначе
		Возврат СтрШаблон(НСтр("ru = '%1: %2, уровень воронки: %3'"), Заголовок,
		ПараметрыРасшифровки.ПолеГруппировки, УровеньВоронки);
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПредставлениеРасшифровкиЛиды(ПараметрыРасшифровки)
	
	Возврат СтрШаблон(НСтр("ru = '%1: %2, уровень воронки: %3'"),
	?(ПараметрыРасшифровки.ЭтоПотери, НСтр("ru = 'Потери'"), НСтр("ru = 'Лиды'")),
	?(ТипЗнч(ПараметрыРасшифровки.ПолеГруппировки) = Тип("Булево"), НСтр("ru = 'Все'"),ПараметрыРасшифровки.ПолеГруппировки),
	ПараметрыРасшифровки.Состояние);
	
КонецФункции

&НаСервере
Функция СтрокаФильтровПоПокупателям(Состояние)
	
	Если Состояние = "ВедетсяРабота" Тогда
		Возврат "ВТ_Лиды.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантыЗавершенияЗаказа.ПустаяСсылка)";
	КонецЕсли;
	
	Если Состояние = "ОтменилиЗаказ" Тогда
		Возврат "ВТ_Лиды.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантыЗавершенияЗаказа.Отменен)";
	КонецЕсли;
		
КонецФункции

&НаСервере
Функция СтрокаФильтровПоПродажам(Состояние)
	
	Если Состояние = "НетПродаж" Тогда
		
		Возврат " ВТ_ДанныеВоронкиПоПокупателям.Выручка ЕСТЬ NULL
				|И ВТ_ДанныеВоронкиПоПокупателям.Прибыль ЕСТЬ NULL
				|	И ВТ_ДанныеВоронкиПоПокупателям.КоличествоЗаказов = 0";
		
	Иначе
		Возврат "ИСТИНА";
	КонецЕсли;
	
			
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиПоЗаказу(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
	
	ЗапросРасшифровка = Новый Запрос;
	Если ВидВоронки = Отчеты.ВоронкаПродаж.ВидВоронкиПоЗаказам() ИЛИ ВидВоронки = Отчеты.ВоронкаПродаж.ВидВоронкиОбщая() Тогда
		ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЗаказам(НастройкиКД, "Заказ");
	ИначеЕсли ВидВоронки = Отчеты.ВоронкаПродаж.ВидВоронкиПоЛидам() Тогда
		ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЗаказам(НастройкиКД, "Лид");
	ИначеЕсли ВидВоронки = Отчеты.ВоронкаПродаж.ВидВоронкиПоПокупателям() Тогда
		ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЗаказам(НастройкиКД, "Покупатель");
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ЭтоПотери Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИсторияСостоянийЗаказовСрезПоследних.Период КАК Период,
		|	ИсторияСостоянийЗаказовСрезПоследних.Заказ КАК Заказ,
		|	ИсторияСостоянийЗаказовСрезПоследних.Заказ.Контрагент КАК Контрагент,
		|	ИсторияСостоянийЗаказовСрезПоследних.Заказ.Ответственный КАК Ответственный,
		|	ИсторияСостоянийЗаказовСрезПоследних.Заказ.ПричинаОтмены КАК ПричинаОтмены,
		|	ВТ_ДанныеВоронкиПродаж.СуммаДокумента КАК СуммаДокумента,
		|	1 КАК Потеря
		|ИЗ
		|	РегистрСведений.ИсторияСостоянийЗаказов.СрезПоследних(
		|			,
		|			Заказ.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантыЗавершенияЗаказа.Отменен)
		|				И Состояние <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.Завершен)
		|				И Состояние <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказНарядов.Завершен)
		|				И Заказ В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_Заказы.Заказ
		|					ИЗ
		|						ВТ_Заказы)) КАК ИсторияСостоянийЗаказовСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиКонтрагентЛид КАК СвязиКонтрагентЛид
		|		ПО (СвязиКонтрагентЛид.Контрагент = ИсторияСостоянийЗаказовСрезПоследних.Заказ.Контрагент)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеВоронкиПродаж КАК ВТ_ДанныеВоронкиПродаж
		|		ПО (ВТ_ДанныеВоронкиПродаж.Состояние = ИсторияСостоянийЗаказовСрезПоследних.Состояние)
		|			И ИсторияСостоянийЗаказовСрезПоследних.Заказ = ВТ_ДанныеВоронкиПродаж.Заказ
		|ГДЕ
		|	&ПолеГруппировкиЗаказы = &ЗначениеПоляГруппировки
		|	И ИсторияСостоянийЗаказовСрезПоследних.Заказ.ВидЗаказа = &ВидЗаказа
		|	И ИсторияСостоянийЗаказовСрезПоследних.Состояние = &Состояние
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПричинаОтмены,
		|	ИсторияСостоянийЗаказовСрезПоследних.Период";
		
		Если ВариантВоронки = Отчеты.ВоронкаПродаж.ВидВоронкиПоЛидам() Тогда
			ЗапросРасшифровка.Текст = Отчеты.ВоронкаПродаж.ТекстЗапросаСУстановленнымПолемГруппировки(ТекстЗапроса, "СвязиКонтрагентЛид", НастройкиКД, "Заказ");
		Иначе
			ЗапросРасшифровка.Текст = Отчеты.ВоронкаПродаж.ТекстЗапросаСУстановленнымПолемГруппировки(ТекстЗапроса, "ИсторияСостоянийЗаказовСрезПоследних", НастройкиКД, "Заказ");
		КонецЕсли;
		
	Иначе
		ЗапросРасшифровка.Текст =
		"ВЫБРАТЬ
		|	ВТ_ДанныеВоронкиПродаж.Заказ КАК Заказ,
		|	ВТ_ДанныеВоронкиПродаж.Заказ.СостояниеЗаказа КАК ТекущееСостояние,
		|	ВТ_ДанныеВоронкиПродаж.Заказ.ВариантЗавершения КАК ВариантЗавершения,
		|	ВТ_ДанныеВоронкиПродаж.Заказ.Контрагент КАК Контрагент,
		|	ВТ_ДанныеВоронкиПродаж.Заказ.Ответственный КАК Ответственный,
		|	ВТ_ДанныеВоронкиПродаж.СуммаДокумента * ВТ_ДанныеВоронкиПродаж.УчитыватьВВоронке КАК СуммаДокумента
		|ИЗ
		|	ВТ_ДанныеВоронкиПродаж КАК ВТ_ДанныеВоронкиПродаж
		|ГДЕ
		|	ВТ_ДанныеВоронкиПродаж.ПолеГруппировки = &ЗначениеПоляГруппировки
		|	И ВТ_ДанныеВоронкиПродаж.ВидЗаказа = &ВидЗаказа
		|	И ВТ_ДанныеВоронкиПродаж.Состояние = &Состояние
		|	И ВТ_ДанныеВоронкиПродаж.УчитыватьВВоронке = 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_ДанныеВоронкиПродаж.Заказ.Дата";
	КонецЕсли;
	
	ЗапросРасшифровка.УстановитьПараметр("ЗначениеПоляГруппировки", ПараметрыРасшифровки.ПолеГруппировки);
	ЗапросРасшифровка.УстановитьПараметр("ВидЗаказа", ПараметрыРасшифровки.ВидЗаказа);
	ЗапросРасшифровка.УстановитьПараметр("Состояние", ПараметрыРасшифровки.Состояние);
	
	ТабРезультатРасшифровки = Новый ТабличныйДокумент;
	ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
	ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
	ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
	
	Если ПараметрыРасшифровки.ЭтоПотери Тогда
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаПотери");
	Иначе
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_Расшифровка");
	КонецЕсли;
	ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ПредставлениеРасшифровки = ПредставлениеРасшифровки(ПараметрыРасшифровки);
	ТабРезультатРасшифровки.Вывести(ОбластьШапка);
	
	РезультатЗапроса = ЗапросРасшифровка.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
		Возврат ТабРезультатРасшифровки;
	КонецЕсли;
	
	ЦветаГрадиента = НастройкиКД.ДополнительныеСвойства.ЦветаГрадиентаЗаказы;
	
	НомерСтроки = 0;
	СуммаИтог = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока = ПолучитьОбластьРасшифровки(МакетРасшифровки, Выборка, ПараметрыРасшифровки.ЭтоПотери, ПараметрыРасшифровки.Состояние);
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.Заказ = Выборка.Заказ;
		ОбластьСтрока.Параметры.Контрагент = Выборка.Контрагент;
		ОбластьСтрока.Параметры.Ответственный = Выборка.Ответственный;
		ОбластьСтрока.Параметры.СуммаДокумента =  Формат(Выборка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2");
		Если ПараметрыРасшифровки.ЭтоПотери Тогда
			ОбластьСтрока.Параметры.ПричинаОтмены = Выборка.ПричинаОтмены;
			Если ТипЗнч(ЦветаГрадиента[Выборка.ПричинаОтмены]) = Тип("Цвет") Тогда
				ОбластьСтрока.Область("R1C3:R1C3").ЦветФона = ЦветаГрадиента[Выборка.ПричинаОтмены];
			КонецЕсли;
		Иначе
			ОбластьСтрока.Параметры.ТекущееСостояние = Выборка.ТекущееСостояние;
		КонецЕсли;
		СуммаИтог = СуммаИтог + ?(ЗначениеЗаполнено(Выборка.СуммаДокумента), Выборка.СуммаДокумента, 0);
		ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ОбластьПодвал = МакетРасшифровки.ПолучитьОбласть("Подвал");
	ОбластьПодвал.Параметры.СуммаИтог = СуммаИтог;
	ТабРезультатРасшифровки.Вывести(ОбластьПодвал);
	
	Возврат ТабРезультатРасшифровки;
	
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиПоПокупателю(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
	ЗапросРасшифровка = Новый Запрос;
	
	Если ПараметрыРасшифровки.ВидОбъекта = "Лид" Тогда
		ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЛидам(НастройкиКД);
	ИначеЕсли ПараметрыРасшифровки.ВидОбъекта = "Покупатель" Тогда
		ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоПокупателям(НастройкиКД);
	КонецЕсли;
	
	Если ПараметрыРасшифровки.Состояние = "НетПродаж" ИЛИ ПараметрыРасшифровки.Состояние = "Всего" Тогда
		
		ЗапросРасшифровка.Текст = 
		"ВЫБРАТЬ
		|	ВТ_ДанныеВоронкиПоПокупателям.Покупатель КАК Покупатель,
		|	ВТ_ДанныеВоронкиПоПокупателям.Покупатель.Ответственный КАК Ответственный
		|ИЗ
		|	ВТ_ДанныеВоронкиПоПокупателям КАК ВТ_ДанныеВоронкиПоПокупателям
		|ГДЕ
		|	ВТ_ДанныеВоронкиПоПокупателям.ПолеГруппировки = &ЗначениеПоляГруппировки
		|	И &ФильтрНетПродаж";
		
		ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрНетПродаж", СтрокаФильтровПоПродажам(ПараметрыРасшифровки.Состояние));
		ЗапросРасшифровка.УстановитьПараметр("ЗначениеПоляГруппировки", ПараметрыРасшифровки.ПолеГруппировки);
		
		ТабРезультатРасшифровки = Новый ТабличныйДокумент;
		ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
		ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
		ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
		
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаПокупатели");
		
		ОбластьЗаголовок = МакетРасшифровки.ПолучитьОбласть("СтрокаЗаголовок");
		ОбластьЗаголовок.Параметры.ПредставлениеРасшифровки = ПредставлениеРасшифровкиПокупатели(ПараметрыРасшифровки);
		ТабРезультатРасшифровки.Вывести(ОбластьЗаголовок);
		
		Если ПараметрыРасшифровки.ВидОбъекта = "Покупатель" Тогда
			ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("ШапкаПокупатель");
		ИначеЕсли ПараметрыРасшифровки.ВидОбъекта = "Лид" Тогда
			ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("ШапкаЛид");
		КонецЕсли;
		
		ТабРезультатРасшифровки.Вывести(ОбластьШапка);
		
		РезультатЗапроса = ЗапросРасшифровка.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
			Возврат ТабРезультатРасшифровки;
		КонецЕсли;
		
		НомерСтроки = 0;
		СуммаИтог = 0;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НомерСтроки = НомерСтроки + 1;
			ОбластьСтрока = МакетРасшифровки.ПолучитьОбласть("Строка");
			ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
			ОбластьСтрока.Параметры.Контрагент = Выборка.Покупатель;
			ОбластьСтрока.Параметры.Ответственный = Выборка.Ответственный;
			
			ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		Возврат ТабРезультатРасшифровки;
		
	КонецЕсли;
	
	ЗапросРасшифровка.Текст =
	"ВЫБРАТЬ
	|	ВТ_Лиды.Лид КАК Покупатель,
	|	ВТ_Лиды.Лид.Ответственный КАК Ответственный,
	|	ВТ_Лиды.Заказ КАК Заказ,
	|	ВТ_Лиды.СуммаДокумента КАК СуммаДокумента,
	|	ВТ_Лиды.СостояниеЗаказа КАК Состояние,
	|	ВТ_Лиды.ВариантЗавершения КАК ВариантЗавершения,
	|	ВТ_Лиды.ПричинаОтмены КАК ПричинаОтмены
	|ИЗ
	|	ВТ_Лиды КАК ВТ_Лиды
	|ГДЕ
	|	ВТ_Лиды.ПолеГруппировки = &ЗначениеПоляГруппировки
	|	И &ФильтрПоСостоянию
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Лиды.Лид.ДатаСоздания";
	
	
	ЗапросРасшифровка.УстановитьПараметр("ЗначениеПоляГруппировки", ПараметрыРасшифровки.ПолеГруппировки);
	
	ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоСостоянию", СтрокаФильтровПоПокупателям(ПараметрыРасшифровки.Состояние));
	
	Если ПараметрыРасшифровки.ВидОбъекта = "Покупатель" Тогда
		ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "ВТ_Лиды", "ВТ_Покупатели");
		ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "Лид", "Покупатель");
	КонецЕсли;
	
	ТабРезультатРасшифровки = Новый ТабличныйДокумент;
	ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
	ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
	ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
	
	Если ПараметрыРасшифровки.Состояние = "ВедетсяРабота" Тогда
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_Расшифровка");
	Иначе
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаПотери");
	КонецЕсли;
	
	ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ПредставлениеРасшифровки = ПредставлениеРасшифровкиПокупатели(ПараметрыРасшифровки);
	ТабРезультатРасшифровки.Вывести(ОбластьШапка);
	
	РезультатЗапроса = ЗапросРасшифровка.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
		Возврат ТабРезультатРасшифровки;
	КонецЕсли;
	
	ЦветаГрадиента = НастройкиКД.ДополнительныеСвойства.ЦветаГрадиентаЗаказы;
	
	НомерСтроки = 0;
	СуммаИтог = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока = ПолучитьОбластьРасшифровки(МакетРасшифровки, Выборка, ПараметрыРасшифровки.ЭтоПотери, ПараметрыРасшифровки.Состояние);
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.Заказ = Выборка.Заказ;
		ОбластьСтрока.Параметры.Контрагент = Выборка.Покупатель;
		ОбластьСтрока.Параметры.Ответственный = Выборка.Ответственный;
		ОбластьСтрока.Параметры.СуммаДокумента =  Формат(Выборка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2");
		
		Если ПараметрыРасшифровки.Состояние = "ОтменилиЗаказ" Тогда
			ОбластьСтрока.Параметры.ПричинаОтмены = Выборка.ПричинаОтмены;
		Иначе
			ОбластьСтрока.Параметры.ТекущееСостояние = Выборка.Состояние;
		КонецЕсли;
		
		СуммаИтог = СуммаИтог + ?(ЗначениеЗаполнено(Выборка.СуммаДокумента), Выборка.СуммаДокумента, 0);
		ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ОбластьПодвал = МакетРасшифровки.ПолучитьОбласть("Подвал");
	ОбластьПодвал.Параметры.СуммаИтог = СуммаИтог;
	ТабРезультатРасшифровки.Вывести(ОбластьПодвал);
	
	Возврат ТабРезультатРасшифровки;
	
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиПоЛиду(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
	
	ЗапросРасшифровка = Новый Запрос;
	ЗапросРасшифровка.МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЛидам(НастройкиКД);
	
	Если ПараметрыРасшифровки.ЭтоПотери Тогда
		ЗапросРасшифровка.Текст = Отчеты.ВоронкаПродаж.ТекстЗапросаСУстановленнымПолемГруппировки(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИсторияСостоянийЛидовСрезПоследних.Период КАК Период,
		|	ИсторияСостоянийЛидовСрезПоследних.Лид КАК Лид,
		|	ИсторияСостоянийЛидовСрезПоследних.Лид.Ответственный КАК Ответственный,
		|	ИсторияСостоянийЛидовСрезПоследних.Лид.ПричинаНеуспешногоЗавершенияРаботы КАК ПричинаОтмены,
		|	1 КАК Потеря
		|ИЗ
		|	РегистрСведений.ИсторияСостоянийЛидов.СрезПоследних(
		|			,
		|			Лид.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.НекачественныйЛид)
		|				И Состояние <> ЗНАЧЕНИЕ(Справочник.СостоянияЛидов.Завершен)
		|				И Лид В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_Лиды.Лид
		|					ИЗ
		|						ВТ_Лиды)) КАК ИсторияСостоянийЛидовСрезПоследних
		|ГДЕ
		|	&ПолеГруппировкиЛиды = &ЗначениеПоляГруппировки
		|	И ИсторияСостоянийЛидовСрезПоследних.Состояние = &Состояние
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПричинаОтмены,
		|	ИсторияСостоянийЛидовСрезПоследних.Период",
		"ИсторияСостоянийЛидовСрезПоследних",
		НастройкиКД, "Лид");
	Иначе
		ЗапросРасшифровка.Текст =
		"ВЫБРАТЬ
		|	ВТ_ДанныеВоронкиПродаж.Лид КАК Лид,
		|	ВТ_ДанныеВоронкиПродаж.Лид.СостояниеЛида КАК ТекущееСостояние,
		|	ВТ_ДанныеВоронкиПродаж.Лид.ВариантЗавершения КАК ВариантЗавершения,
		|	ВТ_ДанныеВоронкиПродаж.Лид.Ответственный КАК Ответственный
		|ИЗ
		|	ВТ_ДанныеВоронкиПродажЛиды КАК ВТ_ДанныеВоронкиПродаж
		|ГДЕ
		|	ВТ_ДанныеВоронкиПродаж.ПолеГруппировки = &ЗначениеПоляГруппировки
		|	И ВТ_ДанныеВоронкиПродаж.Состояние = &Состояние
		|	И ВТ_ДанныеВоронкиПродаж.УчитыватьВВоронке = 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_ДанныеВоронкиПродаж.Лид.ДатаСоздания";
	КонецЕсли;
	
	ЗапросРасшифровка.УстановитьПараметр("ЗначениеПоляГруппировки", ПараметрыРасшифровки.ПолеГруппировки);
	ЗапросРасшифровка.УстановитьПараметр("Состояние", ПараметрыРасшифровки.Состояние);
	
	ТабРезультатРасшифровки = Новый ТабличныйДокумент;
	ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
	ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
	ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
	
	Если ПараметрыРасшифровки.ЭтоПотери Тогда
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаПотериЛиды");
	Иначе
		МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаЛиды");
	КонецЕсли;
	
	ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ПредставлениеРасшифровки = ПредставлениеРасшифровкиЛиды(ПараметрыРасшифровки);
	ТабРезультатРасшифровки.Вывести(ОбластьШапка);
	
	РезультатЗапроса = ЗапросРасшифровка.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
		Возврат ТабРезультатРасшифровки;
	КонецЕсли;
	
	ЦветаГрадиента = НастройкиКД.ДополнительныеСвойства.ЦветаГрадиентаЛиды;
	
	НомерСтроки = 0;
	СуммаИтог = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока = ПолучитьОбластьРасшифровки(МакетРасшифровки, Выборка, ПараметрыРасшифровки.ЭтоПотери, ПараметрыРасшифровки.Состояние);
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.Лид = Выборка.Лид;
		ОбластьСтрока.Параметры.Ответственный = Выборка.Ответственный;
		
		Если ПараметрыРасшифровки.ЭтоПотери Тогда
			ОбластьСтрока.Параметры.ПричинаОтмены = Выборка.ПричинаОтмены;
			Если ТипЗнч(ЦветаГрадиента[Выборка.ПричинаОтмены]) = Тип("Цвет") Тогда
				ОбластьСтрока.Область("R1C3:R1C3").ЦветФона = ЦветаГрадиента[Выборка.ПричинаОтмены];
			КонецЕсли;
		Иначе
			ОбластьСтрока.Параметры.ТекущееСостояние = Выборка.ТекущееСостояние;
			ОбластьСтрока.Параметры.ВариантЗавершения = Выборка.ВариантЗавершения;
		КонецЕсли;
		ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ОбластьПодвал = МакетРасшифровки.ПолучитьОбласть("Подвал");
	
	Возврат ТабРезультатРасшифровки;
	
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиРасходы(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
	
	ЗапросРасшифровка = Новый Запрос;
	ЗапросРасшифровка.Текст = 
	"ВЫБРАТЬ
	|	РасходыНаИсточникиПривлечения.ДатаНачала КАК ДатаНачала,
	|	РасходыНаИсточникиПривлечения.ДатаОкончания КАК ДатаОкончания,
	|	РасходыНаИсточникиПривлечения.ПлановаяСумма КАК ПлановаяСумма,
	|	РасходыНаИсточникиПривлечения.ПлановаяВыручка КАК ПлановаяВыручка,
	|	РасходыНаИсточникиПривлечения.ИсточникПривлечения КАК ИсточникПривлечения,
	|	РасходыНаИсточникиПривлечения.ПлановоеКоличествоЛидов КАК ПлановоеКоличествоЛидов,
	|	РасходыНаИсточникиПривлечения.ПлановоеКоличествоПокупателей КАК ПлановоеКоличествоПокупателей,
	|	РасходыНаИсточникиПривлечения.ПлановоеКоличествоЗаказов КАК ПлановоеКоличествоЗаказов,
	|	РасходыНаИсточникиПривлечения.ФактическаяСумма КАК ФактическаяСумма
	|ИЗ
	|	РегистрСведений.РасходыНаИсточникиПривлечения КАК РасходыНаИсточникиПривлечения
	|ГДЕ
	|	&ФильтрПоИсточнику";
	
	ЗапросРасшифровка = ЗапросСФильтромПоИсточнику(ЗапросРасшифровка,"РасходыНаИсточникиПривлечения", ПараметрыРасшифровки);

	ТабРезультатРасшифровки = Новый ТабличныйДокумент;
	ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
	ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
	ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
	
	МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаРасходы");	
	
	ОбластьЗаголовок = МакетРасшифровки.ПолучитьОбласть("СтрокаЗаголовок");
	ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("Шапка");
	ЗаголовокИсточники = ПараметрыРасшифровки.Источник;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыРасшифровки.Источник) Тогда
		ЗаголовокИсточники = ?(ПараметрыРасшифровки.ЭтоИтоги, НСтр("ru = 'Итого'"), НСтр("ru = '<Нет группы>'"));
	КонецЕсли;
	
	ОбластьЗаголовок.Параметры.ПредставлениеРасшифровки = СтрШаблон(НСтр("ru = 'Расходы по : %1'"), ЗаголовокИсточники);
	ТабРезультатРасшифровки.Вывести(ОбластьЗаголовок);
	ТабРезультатРасшифровки.Вывести(ОбластьШапка);
	
	РезультатЗапроса = ЗапросРасшифровка.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
		Возврат ТабРезультатРасшифровки;
	КонецЕсли;
	
	НомерСтроки = 0;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока = МакетРасшифровки.ПолучитьОбласть("Строка");

		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.ДатаНачала = Формат(Выборка.ДатаНачала, "ДЛФ=Д");
		ОбластьСтрока.Параметры.ДатаОкончания = Формат(Выборка.ДатаОкончания, "ДЛФ=Д");
		ОбластьСтрока.Параметры.Источник = Выборка.ИсточникПривлечения;
		ОбластьСтрока.Параметры.РасходыПлан = Формат(Выборка.ПлановаяСумма, "ЧЦ=15; ЧДЦ=2");
		ОбластьСтрока.Параметры.РасходыФакт = Формат(Выборка.ФактическаяСумма, "ЧЦ=15; ЧДЦ=2");
		ОбластьСтрока.Параметры.ВыручкаПлан = Формат(Выборка.ПлановаяВыручка, "ЧЦ=15; ЧДЦ=2");
		
		ОбластьСтрока.Параметры.ЛидыПлан = Выборка.ПлановоеКоличествоЛидов;
		ОбластьСтрока.Параметры.ПокупателиПлан = Выборка.ПлановоеКоличествоПокупателей;
		ОбластьСтрока.Параметры.ЗаказыПлан = Выборка.ПлановоеКоличествоЗаказов;

		ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
		
	КонецЦикла;
		
	Возврат ТабРезультатРасшифровки;
	
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиИсточник(НастройкиКД, ПараметрыРасшифровки, ВариантВоронки, ВидВоронки)
	
	ЗапросРасшифровка = Новый Запрос;
	ЗапросРасшифровка = ЗапросПоИсточникам(ЗапросРасшифровка, ПараметрыРасшифровки.ОбъектВоронки, ПараметрыРасшифровки);
	ЗапросРасшифровка.МенеджерВременныхТаблиц = ВременныеТаблицыПоИсточникам(ПараметрыРасшифровки.ОбъектВоронки, НастройкиКД);
	
	ТабРезультатРасшифровки = Новый ТабличныйДокумент;
	ТабРезультатРасшифровки.ТолькоПросмотр = Истина;
	ТабРезультатРасшифровки.ОтображатьСетку = Ложь;
	ТабРезультатРасшифровки.ОтображатьЗаголовки = Ложь;
	
	МакетРасшифровки = Отчеты.ВоронкаПродаж.ПолучитьМакет("ТД_РасшифровкаИсточник");	
	
	ОбластьШапка = МакетРасшифровки.ПолучитьОбласть("Шапка");
	ЗаголовокИсточники = ПараметрыРасшифровки.Источник;
	
	ОбластьШапка.Параметры.Объект = ПараметрыРасшифровки.ОбъектВоронки;
	ТабРезультатРасшифровки.Вывести(ОбластьШапка);
	
	РезультатЗапроса = ЗапросРасшифровка.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТабРезультатРасшифровки.Вывести(МакетРасшифровки.ПолучитьОбласть("СтрокаОтсутствуютДанные"));
		Возврат ТабРезультатРасшифровки;
	КонецЕсли;
	
	НомерСтроки = 0;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.ИсточникПривлечения) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока = МакетРасшифровки.ПолучитьОбласть("Строка");

		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.ОбъектЗначение = Выборка.Ссылка;
		ОбластьСтрока.Параметры.Источник = Выборка.ИсточникПривлечения;
		ОбластьСтрока.Параметры.Конверсия = Выборка.Конверсия;
		
		ТабРезультатРасшифровки.Вывести(ОбластьСтрока);
		
	КонецЦикла;
		
	Возврат ТабРезультатРасшифровки;
	
КонецФункции

&НаСервере
Функция ЗапросСФильтромПоИсточнику(Запрос, Таблица, ПараметрыРасшифровки)
	
	Если ПараметрыРасшифровки.ЭтоИтоги Тогда
		ФильтрПоИсточнику = "ИСТИНА";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрПоИсточнику", ФильтрПоИсточнику);
		Возврат Запрос;
	КонецЕсли;
	
	Если ПараметрыРасшифровки.ЭтоГруппа Тогда
		ФильтрПоИсточнику = СтрШаблон("%1.ИсточникПривлечения.Родитель = &ИсточникПривлечения", Таблица);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрПоИсточнику", ФильтрПоИсточнику);
	Иначе
		ФильтрПоИсточнику = СтрШаблон("%1.ИсточникПривлечения = &ИсточникПривлечения", Таблица);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФильтрПоИсточнику", ФильтрПоИсточнику);
	КонецЕсли;
	
	ИсточникПривлечения = ПараметрыРасшифровки.Источник;
	Если НЕ ЗначениеЗаполнено(ИсточникПривлечения) Тогда
		ИсточникПривлечения = Справочники.ИсточникиПривлеченияПокупателей.ПустаяСсылка();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ИсточникПривлечения", ИсточникПривлечения);
		
	Возврат Запрос;
	
КонецФункции

&НаСервере
Функция ЗапросПоИсточникам(ЗапросРасшифровка, ОбъектВоронки, ПараметрыРасшифровки)
	
	Если ОбъектВоронки = "Лид" Тогда
		
		ЗапросРасшифровка.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Лиды.Лид КАК Ссылка,
		|	ВТ_Лиды.ИсточникПривлечения КАК ИсточникПривлечения,
		|	ВТ_Лиды.Лид.ВариантЗавершения КАК Конверсия
		|ИЗ
		|	ВТ_Лиды КАК ВТ_Лиды
		|ГДЕ
		|	НЕ ВТ_Лиды.ИсточникПривлечения ЕСТЬ NULL
		|	И &ФильтрПоИсточнику
		|	И &ФильтрПоКонверсии";
		
		ЗапросРасшифровка = ЗапросСФильтромПоИсточнику(ЗапросРасшифровка, "ВТ_Лиды", ПараметрыРасшифровки);
		
		Если ПараметрыРасшифровки.ЭтоКонверсия Тогда
			СтрФильтр = "ВТ_Лиды.Лид.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.ПереведенВПокупателя)";
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", СтрФильтр);
		Иначе
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", "ИСТИНА");
		КонецЕсли;
		
		Возврат ЗапросРасшифровка;
		
	КонецЕсли;
	
	Если ОбъектВоронки = "Покупатель" Тогда
		
		ЗапросРасшифровка.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_ДанныеВоронкиПоПокупателям.Покупатель КАК Ссылка,
		|	ВТ_ДанныеВоронкиПоПокупателям.ИсточникПривлечения КАК ИсточникПривлечения,
		|	ВЫБОР
		|		КОГДА НЕ ВТ_ДанныеВоронкиПоПокупателям.Выручка ЕСТЬ NULL
		|				И НЕ ВТ_ДанныеВоронкиПоПокупателям.Прибыль ЕСТЬ NULL
		|			ТОГДА ""Совершена продажа""
		|	КОНЕЦ КАК Конверсия
		|ИЗ
		|	ВТ_ДанныеВоронкиПоПокупателям КАК ВТ_ДанныеВоронкиПоПокупателям
		|ГДЕ
		|	НЕ ВТ_ДанныеВоронкиПоПокупателям.ИсточникПривлечения ЕСТЬ NULL
		|	И &ФильтрПоИсточнику
		|	И &ФильтрПоКонверсии";
		
		ЗапросРасшифровка = ЗапросСФильтромПоИсточнику(ЗапросРасшифровка, "ВТ_ДанныеВоронкиПоПокупателям", ПараметрыРасшифровки);
		
		Если ПараметрыРасшифровки.ЭтоКонверсия Тогда
			СтрФильтр = "НЕ ВТ_ДанныеВоронкиПоПокупателям.Выручка ЕСТЬ NULL
						|И НЕ ВТ_ДанныеВоронкиПоПокупателям.Прибыль ЕСТЬ NULL";
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", СтрФильтр);
		Иначе
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", "ИСТИНА");
		КонецЕсли;
		
		Возврат ЗапросРасшифровка;

	КонецЕсли;
	
	Если ОбъектВоронки = "Заказ" Тогда
		
		ЗапросРасшифровка.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Заказы.Заказ КАК Ссылка,
		|	ВТ_Заказы.ИсточникПривлечения КАК ИсточникПривлечения,
		|	ВТ_Заказы.ВариантЗавершения КАК Конверсия
		|ИЗ
		|	ВТ_Заказы КАК ВТ_Заказы
		|ГДЕ
		|	НЕ ВТ_Заказы.ИсточникПривлечения ЕСТЬ NULL
		|	И &ФильтрПоИсточнику
		|	И &ФильтрПоКонверсии";
		
		ЗапросРасшифровка = ЗапросСФильтромПоИсточнику(ЗапросРасшифровка, "ВТ_Заказы", ПараметрыРасшифровки);
		
		Если ПараметрыРасшифровки.ЭтоКонверсия Тогда
			СтрФильтр = "ВТ_Заказы.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантыЗавершенияЗаказа.Успешно)";
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", СтрФильтр);
		Иначе
			ЗапросРасшифровка.Текст = СтрЗаменить(ЗапросРасшифровка.Текст, "&ФильтрПоКонверсии", "ИСТИНА");
		КонецЕсли;
		
		Возврат ЗапросРасшифровка;

	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ВременныеТаблицыПоИсточникам(ОбъектВоронки, НастройкиКД)
	
	Если ОбъектВоронки = "Лид" Тогда
		МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЛидам(НастройкиКД);
	КонецЕсли;
	
	Если ОбъектВоронки = "Покупатель" Тогда
		МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоПокупателям(НастройкиКД);
	КонецЕсли;
	
	Если ОбъектВоронки = "Заказ" Тогда
		МенеджерВременныхТаблиц = Отчеты.ВоронкаПродаж.ВременныеТаблицыВоронкиПродажПоЗаказам(НастройкиКД,ОбъектВоронки);
	КонецЕсли;
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти