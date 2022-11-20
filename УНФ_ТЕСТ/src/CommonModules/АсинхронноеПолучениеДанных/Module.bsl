// @strict-types

#Область ПрограммныйИнтерфейс

// Возвращает идентификатор хранилища в виде строки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Строка - идентификатор хранилища. 
//
Функция ИдентификаторХранилища() Экспорт
КонецФункции

// Возвращает новую структуру описания возвращаемых данных.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Структура:
//	 * МодульМенеджер - ОбщийМодуль, СправочникиМенеджер, ОтчетыМенеджер - модуль менеджера получения данных.
//	 * Наименование - Строка - наименование возвращаемых данных.
//	 * Описание - Строка - подробное описание возвращаемых данных.
//	 * ТипыРезультата - Массив - типы возвращаемых данных.
//	 
Функция НовыйОписаниеВозвращаемыхДанных() Экспорт
КонецФункции

// Возвращает перечень доступных данных
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Соответствие из КлючИЗначение - перечень доступных возвращаемых данных:
//	 * Ключ - Строка - идентификатор данных.
//	 * Значение - см. АсинхронноеПолучениеДанных.НовыйОписаниеВозвращаемыхДанных
//	
Функция ДоступныеВозвращаемыеДанные() Экспорт
КонецФункции

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
// @skip-warning ПустойМетод - особенность реализации.
// Параметры:
//  СоответствиеИменПсевдонимам - см. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.СоответствиеИменПсевдонимам
// 
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
КонецПроцедуры

#Область ОбработчикиОчередиЗаданий

// Формирует данные для ответа по полученным параметрам.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	ИдентификаторДанных - Строка - идентификатор данных, которые нужно получить.
//	ИдентификаторПараметров - УникальныйИдентификатор - идентификатор файла параметров получения данных.
//
Процедура ПодготовитьДанные(ИдентификаторДанных, ИдентификаторПараметров) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецОбласти
 
