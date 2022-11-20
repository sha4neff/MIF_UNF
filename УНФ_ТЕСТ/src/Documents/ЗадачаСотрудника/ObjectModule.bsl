#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Дата = ТекущаяДатаСеанса();
		Автор = АвторизованныйПользователь;
		Ответственный = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			АвторизованныйПользователь, "ОсновнойОтветственный");
		Календарь = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойКалендарь");
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		ЗаполнитьНаименованиеОписание(ДанныеЗаполнения);
		ЗаполнитьПоДаннымКалендаря(ДанныеЗаполнения);
		ЗаполнитьОснование(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемоеНаименование = ПроверяемыеРеквизиты.Найти("Наименование");
	Если ПроверяемоеНаименование <> Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемоеНаименование);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончания) Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаНачала");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСGoogle.ПередЗаписьюИсточникаЗаписиКалендаря(ЭтотОбъект);
	Наименование = СтрПолучитьСтроку(Описание, 1);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСGoogle.ПриЗаписиИсточникаЗаписиКалендаря(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ПрефиксацияОбъектовСобытия.УстановитьПрефиксИнформационнойБазы(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаименованиеОписание(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения.Свойство("Наименование") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ДанныеЗаполнения.Наименование)
		И НЕ СтрНачинаетсяС(Описание, ДанныеЗаполнения.Наименование) Тогда
		Наименование = ДанныеЗаполнения.Наименование;
		Описание = ДанныеЗаполнения.Наименование + Символы.ПС + Описание;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДаннымКалендаря(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения.Свойство("ДанныеЗаписиКалендаря") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения.ДанныеЗаписиКалендаря.Свойство("Начало",    ДатаНачала);
	ДанныеЗаполнения.ДанныеЗаписиКалендаря.Свойство("Окончание", ДатаОкончания);
	ДанныеЗаполнения.ДанныеЗаписиКалендаря.Свойство("Описание",  Описание);
	
КонецПроцедуры

Процедура ЗаполнитьОснование(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения.Свойство("Основание") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения.Основание) = Тип("Строка") Тогда
		Основание = Неопределено;
		ОснованиеСтроковаяСсылка = ДанныеЗаполнения.Основание;
		ДанныеЗаполнения.Свойство("ОснованиеПредставление", ОснованиеПредставление);
	Иначе
		Основание = ДанныеЗаполнения.Основание;
		ОснованиеСтроковаяСсылка = Неопределено;
		ОснованиеПредставление = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
