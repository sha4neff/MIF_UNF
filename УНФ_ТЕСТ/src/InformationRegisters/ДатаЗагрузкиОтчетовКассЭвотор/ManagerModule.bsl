#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Менеджер = "РегистрСведений.ДатаЗагрузкиОтчетовКассЭвотор";
	МенеджерОборудованияВызовСервераПереопределяемый.ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецЕсли
