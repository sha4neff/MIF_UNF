#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Тип <> Перечисления.ТипыНачисленийИУдержаний.Налог Тогда
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидНалога");
		
	КонецЕсли;
	
	Если Тип = Перечисления.ТипыНачисленийИУдержаний.Удержание 
		ИЛИ Тип = Перечисления.ТипыНачисленийИУдержаний.Налог Тогда
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КодДоходаНДФЛ");
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли