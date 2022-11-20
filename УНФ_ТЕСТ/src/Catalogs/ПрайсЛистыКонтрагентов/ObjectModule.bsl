#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область МетодыЗаполнений

Процедура ПроверитьОбязательныеПоля()
	
	Если Индивидуальный
		И НЕ ЗначениеЗаполнено(Автор) Тогда
		
		Автор = Пользователи.АвторизованныйПользователь();
		
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		
		Наименование = Нстр("ru ='Прайс-листы контрагентов'");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		
		Валюта = Константы.НациональнаяВалюта.Получить();
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УсловнаяЦенаУсловие) Тогда
		
		УсловнаяЦенаУсловие = Перечисления.ВидСравненияЗначений.Меньше;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидЦенКонтрагентаУсловие) Тогда
		
		ВидЦенКонтрагентаУсловие = Перечисления.ВидСравненияЗначений.Равно;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЦенКонтрагента(МассивВидовЦенКонтрагентов)
	
	ОтборВидовЦенКонтрагентов.Очистить();
	Если ТипЗнч(МассивВидовЦенКонтрагентов) <> Тип("Массив") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для каждого ЭлементМассива Из МассивВидовЦенКонтрагентов Цикл
		
		НоваяСтрока = ОтборВидовЦенКонтрагентов.Добавить();
		НоваяСтрока.ВидЦенКонтрагента = ЭлементМассива;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьОтборыНоменклатуры(КоллекцияЭлементов)
	
	Если ТипЗнч(КоллекцияЭлементов) = Тип("ТаблицаЗначений") Тогда
		
		ОтборНоменклатуры.Загрузить(КоллекцияЭлементов);
		
	ИначеЕсли ТипЗнч(КоллекцияЭлементов) = Тип("ОтборКомпоновкиДанных") Тогда
		
		ПрайсЛистыСлужебный.СКДОтборНоменклатурыВТабличнуюЧасть(КоллекцияЭлементов.Элементы, ОтборНоменклатуры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьОтборыНоменклатурыСтандартнымЗначением()
	
	НоваяСтрока = ОтборНоменклатуры.Добавить();
	НоваяСтрока.Имя = "Номенклатура.Недействителен";
	НоваяСтрока.Представление = "Номенклатура.Недействителен";
	НоваяСтрока.ВидСравнения = "Равно";
	НоваяСтрока.Значение = Ложь;
	НоваяСтрока.Использование = Истина;
	
	НоваяСтрока = ОтборНоменклатуры.Добавить();
	НоваяСтрока.Имя = "Номенклатура.ИсключитьИзПрайсЛистов";
	НоваяСтрока.Представление = "Номенклатура.ИсключитьИзПрайсЛистов";
	НоваяСтрока.ВидСравнения = "Равно";
	НоваяСтрока.Значение = Ложь;
	НоваяСтрока.Использование = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьОбъектПоСтруктуре(ДанныеЗаполнения)
	
	ДанныеЗаполнения.Свойство("Автор", 						Автор);
	ДанныеЗаполнения.Свойство("Валюта",						Валюта);
	ДанныеЗаполнения.Свойство("ВариантыСортировки",			ВариантыСортировки);
	ДанныеЗаполнения.Свойство("ВыводитьДатуФормирования",	ВыводитьДатуФормирования);
	ДанныеЗаполнения.Свойство("ДатаРасчетаКурсаВалюты",		ДатаРасчетаКурсаВалюты);
	ДанныеЗаполнения.Свойство("ДатаФормирования",			ДатаФормирования);
	ДанныеЗаполнения.Свойство("ИерархияСодержимого",		ИерархияСодержимого);
	ДанныеЗаполнения.Свойство("Индивидуальный",				Индивидуальный);
	ДанныеЗаполнения.Свойство("НаименованиеПрайсЛиста",		Наименование);
	ДанныеЗаполнения.Свойство("НоменклатураБезЦен", 		НоменклатураБезЦен);
	ДанныеЗаполнения.Свойство("Описание",					Описание);
	ДанныеЗаполнения.Свойство("ПериодЦенКонтрагента",		ПериодЦенКонтрагента);
	
	Если ДанныеЗаполнения.Свойство("ФормироватьПоОтсутствию") Тогда
		
		ФормироватьПоОтсутствию = ДанныеЗаполнения.ФормироватьПоОтсутствию;
		
	Иначе
		
		ФормироватьПоОтсутствию = Ложь;
		
	КонецЕсли;
	
	ДанныеЗаполнения.Свойство("МаксимальнаяЦена", 			МаксимальнаяЦена);
	ДанныеЗаполнения.Свойство("МинимальнаяЦена", 			МинимальнаяЦена);
	
	ДанныеЗаполнения.Свойство("УсловнаяЦена",				УсловнаяЦена);
	ДанныеЗаполнения.Свойство("УсловнаяЦенаУсловие",		УсловнаяЦенаУсловие);
	ДанныеЗаполнения.Свойство("УсловнаяЦенаЗначение",		УсловнаяЦенаЗначение);
	ДанныеЗаполнения.Свойство("УсловнаяЦенаЗначениеДо",		УсловнаяЦенаЗначениеДо);
	
	ДанныеЗаполнения.Свойство("ВидЦенКонтагентаСравнить",	ВидЦенКонтагентаСравнить);
	ДанныеЗаполнения.Свойство("ВидЦенКонтрагента1",			ВидЦенКонтрагента1);
	ДанныеЗаполнения.Свойство("ВидЦенКонтрагентаУсловие",	ВидЦенКонтрагентаУсловие);
	ДанныеЗаполнения.Свойство("ВидЦенКонтрагента2", 		ВидЦенКонтрагента2);
	ДанныеЗаполнения.Свойство("ИсключитьПустыеВидыЦен",		ИсключитьПустыеВидыЦен);
	
	Если ДанныеЗаполнения.Свойство("ВидыЦенКонтрагентов") Тогда
		
		ЗаполнитьВидыЦенКонтрагента(ДанныеЗаполнения.ВидыЦенКонтрагентов);
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ОтборНоменклатуры") Тогда
		
		ЗаполнитьОтборыНоменклатуры(ДанныеЗаполнения.ОтборНоменклатуры);
		
	Иначе
		
		ЗаполнитьОтборыНоменклатурыСтандартнымЗначением();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Перем ТаблицаПредставлений;
	
	ОтборВидовЦенКонтрагентов.Очистить();
	ОтборНоменклатуры.Очистить();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьОбъектПоСтруктуре(ДанныеЗаполнения);
		
	Иначе
		
		ФормироватьПоОтсутствию = Ложь;
		ЗаполнитьОтборыНоменклатурыСтандартнымЗначением();
		
	КонецЕсли;
	
	ПроверитьОбязательныеПоля();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Индивидуальный = Истина;
	Автор = Пользователи.АвторизованныйПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Индивидуальный
		И НЕ ЗначениеЗаполнено(Автор) Тогда
		
		Автор = Пользователи.АвторизованныйПользователь();
		
	КонецЕсли;
	
	Если Недействителен Тогда
		
		ПрайсЛистыСлужебный.ПроверитьВозможностьУстановкиПризнакаНедействителен(Ссылка, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли