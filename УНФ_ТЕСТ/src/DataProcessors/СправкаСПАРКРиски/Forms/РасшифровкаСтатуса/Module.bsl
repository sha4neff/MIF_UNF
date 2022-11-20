///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Статус") Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""Статус"".'");
	КонецЕсли;
	
	ЗначениеРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.Статус,
		"Название, Описание");
	ЭтотОбъект.Заголовок = ЗначениеРеквизитов.Название;
	
	Элементы.ДекорацияОписание.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1.
				|
				|<a href = ""%2"">Подробнее о сервисе</a>'"),
			ЗначениеРеквизитов.Описание,
		СПАРКРискиКлиентСервер.АдресСтраницыОписанияСервисаСПАРКРиски()));
	
КонецПроцедуры

#КонецОбласти