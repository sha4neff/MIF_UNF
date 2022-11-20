#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает цену товара.
//
// Возвращаемое значение:
//  Число
//
Функция ПолучитьЦенуТовара(Товар) Экспорт
	
	ОтборПоНоменклатуре = Новый Структура("Товар", Товар);
	
	Таблица = СрезПоследних(,ОтборПоНоменклатуре);
	Если Таблица.Количество() > 0 Тогда
		Возврат Таблица[0].Цена;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции // ПолучитьЦенуТовара()

#КонецОбласти

#КонецЕсли
