#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Формирует список соответствий полей лида и контрагента
// вызывается при первоначальном заполнении информационной базы
//
Процедура ЗаполнитьПоставляемыеСоответствияРеквизитовЛидаИКонтрагента() Экспорт
	
	НаборЗаписей = РегистрыСведений.СоответствиеПолейЛидаИКонтрагента.СоздатьНаборЗаписей();
	
	СоответствиеНаименование = НаборЗаписей.Добавить();
	СоответствиеНаименование.ИмяРеквизитаЛид        = "Наименование";
	СоответствиеНаименование.ИмяРеквизитаКонтрагент = "Наименование";
	
	СоответствиеКомментарий = НаборЗаписей.Добавить();
	СоответствиеКомментарий.ИмяРеквизитаЛид        = "Комментарий";
	СоответствиеКомментарий.ИмяРеквизитаКонтрагент = "Комментарий";
	
	СоответствиеКомпания = НаборЗаписей.Добавить();
	СоответствиеКомпания.ИмяРеквизитаЛид        = "НаименованиеКомпании";
	СоответствиеКомпания.ИмяРеквизитаКонтрагент = "НаименованиеПолное";
	
	СоответствиеИсточник = НаборЗаписей.Добавить();
	СоответствиеИсточник.ИмяРеквизитаЛид        = "ИсточникПривлечения";
	СоответствиеИсточник.ИмяРеквизитаКонтрагент = "ИсточникПривлеченияПокупателя";

	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли