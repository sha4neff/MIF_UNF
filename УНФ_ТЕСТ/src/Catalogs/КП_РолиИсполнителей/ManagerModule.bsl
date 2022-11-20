#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
// Параметров нет
// Возвращаемое значение: Массив 
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("КраткоеПредставление");
	Результат.Добавить("Комментарий");
	Результат.Добавить("ВнешняяРоль");
	Результат.Добавить("УзелОбмена");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
