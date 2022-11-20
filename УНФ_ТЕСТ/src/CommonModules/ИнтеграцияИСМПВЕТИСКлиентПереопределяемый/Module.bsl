/////////////////////////////////////////////////////////////////////////////
// Совместная работа подсистем ВетИС и ИСМП.
//   * Процедуры взаимодействия с внешним модулем ВетИС
//

#Область ПрограммныйИнтерфейс

#Область ФормаУточненияДанныхИС

// Обработчик выбора произвольного идентификатора происхождения (не из списка выбора)
// 
// Параметры:
//   Форма               - ФормаКлиентскогоПриложения -  ОбщаяФорма.ФормаУточненияДанныхИС
//   СтандартнаяОбработка- Булево - признак стандартной обработки события
//
Процедура ИдентификаторПроисхожденияВЕТИСОбработкаВыбора(Форма, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти